# frozen_string_literal: true

# https://github.com/thoughtbot/factory_bot/issues/359#issuecomment-509216228
module FactoryBot::Syntax::Methods
  def nested_attributes_for(*args)
    attributes = attributes_for(*args)
    klass = args.first.to_s.camelize.constantize

    klass.reflect_on_all_associations(:belongs_to).each do |r|
      association = FactoryBot.create(r.class_name.underscore)
      attributes["#{r.name}_id"] = association.id
      attributes["#{r.name}_type"] = association.class.name if r.options[:polymorphic]
    end

    attributes
  end

  def attributes_for_related(*args)
    attributes = {}
    klass = args.first.to_s.camelize.constantize

    klass.reflect_on_all_associations(:belongs_to).each do |r|
      association = FactoryBot.create(r.class_name.underscore)
      attributes["#{r.name}"] = {
        "data": {
          "id": association.id,
          "type": association.model_name.collection
        }
      }
    end

    attributes
  end
end
