class HashTable
	attr_accessor :buckets

	def initialize
		@buckets = []
	end

	def insert(key, val)
		index = index_from(key)
		
		buckets[index] ||= []
		buckets[index] << [key, val]
	end

	def index_from(key)
		key.to_sym.object_id % 100
	end

	def find(key)
		index = index_from(key)

		buckets[index].each do |item|
			return item[1] if item[0] == key
		end if buckets[index]
	end
end