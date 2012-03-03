class Artists < ActiveRecord::Base
	validates :hash_id, :presence=>true, :uniqueness => true 
	validates :group_name, :presence=>true

end
