class BaseSerializer
  include JSONAPI::Serializer

  def initialize(object)
    @object = object
  end

  def serialize
    {
      id: @object.id,
      type: self.class.name.demodulize.underscore,
      attributes: @object.attributes
    }
  end
end
