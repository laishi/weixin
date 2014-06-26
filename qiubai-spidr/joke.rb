
class Joke
	include Mongoid::Document

	field :title, 		type: String
	field :content, 	type: String
	field :pic_url,		type: String
	field :base_id, 	type: String
	field :from,			type: String

end