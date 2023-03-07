# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  title      :string
#  code       :string
#  stock      :integer          default(0)
#  price      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord

	# save
	before_create :validate_product
	after_create :send_notification
	after_create :push_notification, if: :discount?

	validates :title, presence: { message: 'Es necesario definir un titulo'}
	validates :code, uniqueness: { message: 'El codigo %{value} ya esta en uso'}

	#validates :price, length: {minimum: 3, maximum: 10}
	validates :price, length: { in: 3..10, message: 'Fuera de rango (Min:3, Max:10'}, if: :has_price?

	validate :code_validate
	validates_with ProductValidator

	scope :available, -> (min=50) { where('stock >= ?', min)}
	scope :order_price_desc, -> { order('price DESC') }

	def total
		self.price / 10
	end

	def discount?
		self.total < 100
	end

	def has_price?
		!self.price.nil? && self.price > 0
	end

	private

	def code_validate
		if self.code.nil? || self.code.length <3
			self.errors.add(:code, 'El codigo debe poseer por lo menos 3 caracteres')
		end
	end

	def validate_product
		puts "\n\n\n Se va a crear un producto"
	end
	
	def send_notification
		puts "\n\n\n >>>>>>>>>> Se ha creado un nuevo producto #{self.title} - $#{self.total} USD"
	end

	def push_notification
		puts "\n\n\n >>>>>>>> Un nuevo producto en descuento disponible: #{self.title}"
	end
end
