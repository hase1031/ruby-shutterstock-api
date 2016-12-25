module ShutterstockAPI
	class Image < Driver
		attr_reader :id, :description, :keywords, :categories, :model_releases, :image_type, :media_type,
			:added_date, :assets, :contributor, :releases, :aspect, :images

		def initialize(params = {})
			@hash                       = params
			@id                         = params["id"].to_i
			@illustration               = json_true? params["is_illustration"]
      @editorial                  = json_true? params["is_editorial"]
      @adult                      = json_true? params["is_adult"]
      @aspect                     = params["aspect"]
      @added_date                 = params["added_date"]
      @image_type                 = params["image_type"]
      @media_type                 = params["media_type"]
			@categories                 = params["categories"]
			@model_release              = json_true? params["has_model_release"]
      @property_release           = json_true? params["has_property_release"]
      @releases                   = params["releases"]
      @model_releases             = params["model_releases"]
			@description                = params["description"]
			@keywords                   = params["keywords"]
			@assets                     = params["assets"]
      @contributor                = params["contributor"]
		end

		# boolean readers
		def illustration?
			@illustration
    end

    def editorial?
      @editorial
    end

    def adult?
      @adult
    end

		def model_release?
			@model_release
		end

		def property_release?
			@property_release
		end

		def self.find(opts={})
			self.new(self.get("/images/#{opts[:id]}", client.options).to_hash )
		end

		def find(opts={})
			self.class.find(opts)
		end

		#Image.find_similar(12345, {:page_number => 2, :sort_order => 'random'})
		def self.find_similar(id, options = {})
			opts = client.options
			opts.merge!({ :query => options})
			result = self.get( "/images/#{id}/similar", opts )
			Images.new(result.to_hash)
		end

		#Image.search(client, 'dogs', {:page_number => 2, :sort_order => 'random'})
		def self.search(search, options = {})
			search_params = {}
			if search.kind_of? String
				search_params[:query] = search
			else
				search_params = search
			end
			search_params.merge!(options)
			opts = client.options
			opts.merge!({ :query => search_params })

			Images.new( self.get( "/images/search", opts).to_hash )
		end

		def find_similar(options = {})
			@images = self.class.find_similar(self.id, options)
		end

	end
end
