module ShutterstockAPI
  class Images < Array
    attr_reader :raw_data, :page, :total_count, :per_page, :search_id
    def initialize(raw_data)
      @raw_data = raw_data

      if raw_data.kind_of? Hash
        super(@raw_data["data"].map{ |image| Image.new(image) })

        @total_count   = raw_data["total_count"].to_i
        @per_page      = raw_data["per_page"].to_i
        @page          = raw_data["page"].to_i
        @search_id     = raw_data["search_id"]
      elsif raw_data.kind_of? Array
        super( @raw_data.map{ |image| Image.new(image) } )
      end

      self
    end
  end
end
