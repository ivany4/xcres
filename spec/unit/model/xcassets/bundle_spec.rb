require File.expand_path('../spec_helper', __FILE__)

module XCAssetsSpec
  describe 'XCRes::XCAssets::Bundle' do

    def subject
      Bundle
    end

    describe "::open" do
      it 'should read the bundle at given path' do
        subject.any_instance.expects(:read)
        subject.open('.')
      end
    end

    describe "#initialize" do
      it 'should not require any arguments' do
        -> { subject.new }.should.not.raise?
      end

      describe 'first argument' do
        it 'should box it in Pathname and set it as attribute path' do
          subject.new('.').path.should.be.eql?(Pathname('.'))
        end

        it 'should set it as attribute path' do
          subject.new(Pathname('.')).path.should.be.eql?(Pathname('.'))
        end
      end

      it 'should initialize attribute resources with an empty array' do
        subject.new.resources.should.be.eql?([])
      end
    end

    describe "#read" do
      before do
        @bundle = subject.new(xcassets_fixture_path)
        @bundle.read
      end

      it 'should set the resource paths' do
        @bundle.resource_paths.should.be.eql? [
          Pathname('AppIcon.appiconset'),
          Pathname('Cats/GrumpyCat.imageset'),
          Pathname('Doge.imageset'),
          Pathname('LaunchImage.launchimage'),
          Pathname('Sounds/Aif.dataset'),
          Pathname('Sounds/MP3.dataset'),
          Pathname('Wav.dataset'),
        ]
      end

      shared 'XCAssets resource' do
        path = @name

        before do
          @res = @bundle.resources.find { |r| r.path.to_s == path }
        end

        it 'should match the info' do
          @res.info.should.be.eql?({ "version" => 1, "author" => "xcode" })
        end
      end

      describe 'resources' do
        describe 'AppIcon.appiconset' do
          behaves_like 'XCAssets resource'

          it 'should match the name' do
            @res.name.should.be.eql? 'AppIcon'
          end

          it 'should match the type' do
            @res.type.should.be.eql? 'appiconset'
          end

          it 'should match the images' do
            @res.images.should.be.eql? []
          end
        end

        describe 'Cats/GrumpyCat.imageset' do
          behaves_like 'XCAssets resource'

          it 'should match the name' do
            @res.name.should.be.eql? 'GrumpyCat'
          end

          it 'should match the type' do
            @res.type.should.be.eql? 'imageset'
          end

          it 'should match the info' do
            @res.info.should.be.eql?({ "version" => 1, "author" => "xcode" })
          end

          it 'should match the images' do
            @res.images.should.be.eql? [
                ResourceImage.new(idiom: 'universal', scale: 1, filename: 'GrumpyCat.jpg'),
                ResourceImage.new(idiom: 'universal', scale: 2, filename: 'GrumpyCat@2x.jpg'),
                ResourceImage.new(idiom: 'universal', scale: 3, filename: 'GrumpyCat@3x.jpg'),
            ]
          end
        end

        describe 'Doge.imageset' do
          behaves_like 'XCAssets resource'

          it 'should match the name' do
            @res.name.should.be.eql? 'Doge'
          end

          it 'should match the type' do
            @res.type.should.be.eql? 'imageset'
          end

          it 'should match the info' do
            @res.info.should.be.eql?({ "version" => 1, "author" => "xcode" })
          end

          it 'should match the images' do
            @res.images.should.be.eql? [
              ResourceImage.new(idiom: 'universal', scale: 1, filename: 'doge.png'),
              ResourceImage.new(idiom: 'universal', scale: 2, filename: 'doge@2x.png'),
              ResourceImage.new(idiom: 'universal', scale: 3),
            ]
          end
        end

        describe 'LaunchImage.launchimage' do
          behaves_like 'XCAssets resource'

          it 'should match the name' do
            @res.name.should.be.eql? 'LaunchImage'
          end

          it 'should match the type' do
            @res.type.should.be.eql? 'launchimage'
          end

          it 'should match the images' do
            @res.images.should.be.eql? [
                ResourceImage.new({
                  orientation: 'portrait',
                  idiom: 'iphone',
                  extent: 'full-screen',
                  minimum_system_version: '7.0',
                  scale: 2,
                }),
                ResourceImage.new({
                  orientation: 'portrait',
                  idiom: 'iphone',
                  extent: 'full-screen',
                  minimum_system_version: '7.0',
                  scale: 2,
                  subtype: 'retina4',
                }),
            ]
          end
        end
      end
    end

  end
end
