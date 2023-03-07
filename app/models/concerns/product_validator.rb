class ProductValidator < ActiveModel::Validator

	def validate(record)
		self.validate_stock(record)
	end

	def validate_stock(record)
		if record.stock < 0
			record.errors.add(:stock, 'el valor no puede ser negativo.')
		end
	end
end