require 'xcres/builder/file_builder'
require 'xcres/helper/file_helper'

class XCRes::ResourcesBuilder < XCRes::FileBuilder

  include XCRes::FileHelper

  BANNER = <<EOS
// generated by xcres
//
// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// See https://github.com/mrackwitz/xcres for more info.
//
EOS

  COMPILER_KEYWORDS = %w{
    auto break case char const continue default do double else enum extern float
    for goto if inline int long register restrict return short signed sizeof
    static struct switch typedef union unsigned void volatile while
  }

  # @return [String]
  #         the name of the constant in the generated file(s)
  attr_accessor :resources_constant_name

  # @return [Bool]
  #         whether the generated resources constant should contain inline
  #         documentation for each key, true by default
  attr_accessor :documented
  alias :documented? :documented

  # @return [Hash{String => {String => String}|{String => {String => String}}}]
  #         the sections, which will been written to the built files
  attr_reader :sections

  # Initialize a new instance
  #
  def initialize
    @sections = {}
    self.documented = true
  end

  # Extract resource name from #output_path, if not customized
  #
  # @return [String]
  #
  def resources_constant_name
    @resources_constant_name ||= basename_without_ext output_path
  end

  def transform_section_contents section
    raise ArgumentError.new 'No items given!' if section.items.nil?

    transformed_items = {}

    for key, value in section.items

      if value.is_a? XCRes::Section then
        transformed_items[key] = transform_section_contents(value)
      else
        transformed_key = transform_key(key)

        # Skip invalid key names
        if transformed_key.length == 0
          logger.warn "Skip invalid key: '%s'. (Was transformed to empty text)", key
          next
        end

        # Skip compiler keywords
        if COMPILER_KEYWORDS.include? transformed_key
          logger.warn "Skip invalid key: '%s'. (Was transformed to keyword '%s')", key, transformed_key
          next
        end

        transformed_items[transformed_key] = value
      end
    end

    return transformed_items
  end

  def add_section section
    @sections[section.name] = transform_section_contents(section)
  end

  def build
    super

    # Build file contents and write them to disk
    write_file_eventually "#{output_path}.h", (build_contents do |h_file|
      build_header_contents h_file
    end)

    write_file_eventually "#{output_path}.m", (build_contents do |m_file|
      build_impl_contents m_file
    end)
  end

  protected

    def transform_key key, options = {}
      # Split the key into components
      components = key.underscore.split /[_\/ ]/

      # Build the new key incremental
      result = ''

      for component in components
        # Ignore empty components
        next unless component.length > 0

        # Ignore components which are already contained in the key, if enabled
        if options[:shorten_keys]
          next unless result.downcase.scan(component).blank?
        end

        # Clean component from non alphanumeric characters
        clean_component = component.gsub /[^a-zA-Z0-9]/, ''

        # Skip if empty
        next unless clean_component.length > 0

        if result.length == 0
          result += clean_component
        else
          result += clean_component[0].upcase + clean_component[1..-1]
        end
      end

      result
    end

    def fill_header_section struct, parent_key, section_key, section_content
      struct.writeln 'struct %s%s {' % [parent_key, section_key]
      for key, value in section_content.sort
        if value.is_a? Hash then
          struct.section do |substruct|
            fill_header_section(substruct, section_key, key, value)
          end
        else
          struct.section do |substruct|
            comment = nil
            if value.is_a? XCRes::String then
              comment = value.comment
              value = value.value
            end
            if documented?
              substruct.writeln '/// %s' % (comment || value) #unless comment.nil?
            end
            substruct.writeln '__unsafe_unretained NSString *%s;' % key
          end
        end
      end
      struct.writeln '} %s;' % section_key
    end

    def build_header_contents h_file
      h_file.writeln BANNER
      h_file.writeln
      h_file.writeln '#import <Foundation/Foundation.h>'
      h_file.writeln
      h_file.writeln 'extern const struct %s {' % resources_constant_name
      h_file.section do |struct|
        for section_key, section_content in @sections.sort
          fill_header_section(struct, '', section_key, section_content)
        end
      end
      h_file.writeln '} %s;' % resources_constant_name
    end

    def fill_impl_section struct, section_key, section_content
      struct.writeln '.%s = {' % section_key
      for key, value in section_content.sort
        if value.is_a? Hash then
          struct.section do |substruct|
            fill_impl_section(substruct, key, value)
          end
        else
          struct.section do |substruct|
            if value.is_a? XCRes::String then
              value = value.value
            end
            substruct.writeln '.%s = @"%s",' % [key, value]
          end
        end
      end
      struct.writeln '},'
    end

    def build_impl_contents m_file
      m_file.writeln BANNER
      m_file.writeln
      m_file.writeln '#import "R.h"'
      m_file.writeln
      m_file.writeln 'const struct %s %s = {' % [resources_constant_name, resources_constant_name]
      m_file.section do |struct|
        for section_key, section_content in @sections.sort
          fill_impl_section(struct, section_key, section_content)
        end
      end
      m_file.writeln '};'
    end
end
