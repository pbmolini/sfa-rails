class EngineValidator < ActiveModel::Validator
	def validate(record)
		if record.inboard_engine? and record.outboard_engine?
			record.errors[:inboard_engine] << _("They can't be both true!")
			record.errors[:outboard_engine] << _("They can't be both true!")
		end
	end
	
	
end