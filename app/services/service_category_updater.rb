class ServiceCategoryUpdater
  def initialize(attributes)
    @attributes = attributes.map(&:symbolize_keys)
  end

  def call
    attributes.each do |attr|
      service_category = ServiceCategory.find attr[:id]
      service_category.update(attr.extract!(*fields))
    end

    ids = attributes.map { |k| k[:id] }

    ServiceCategory.where(uuid: ids).order(:position)

  rescue StandardError, ScriptError
    false
  end

  private

  attr_reader :attributes

  def fields
    %i(aasm_state position)
  end
end
