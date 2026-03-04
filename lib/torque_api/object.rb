require "ostruct"
require "active_support/core_ext/string/inflections"

module TorqueAPI
  class Base < OpenStruct
    attr_reader :original_response

    def initialize(attributes)
      @original_response = deep_freeze(attributes)
      super(to_ostruct(attributes))
    end

    def to_hash
      ostruct_to_hash(self)
    end

    def raw
      @original_response
    end

    private

    def to_ostruct(obj)
      case obj
      when Hash
        OpenStruct.new(
          obj.transform_keys { |key| key.to_s.underscore }
            .transform_values { |val| to_ostruct(val) }
        )
      when Array
        obj.map { |o| to_ostruct(o) }
      else
        obj
      end
    end

    def deep_freeze(obj)
      case obj
      when Hash then obj.transform_values { |v| deep_freeze(v) }.freeze
      when Array then obj.map { |i| deep_freeze(i) }.freeze
      else obj.respond_to?(:freeze) ? obj.freeze : obj
      end
    end

    def ostruct_to_hash(object)
      case object
      when OpenStruct
        object.each_pair.to_h
          .transform_keys(&:to_s)
          .transform_values { |v| ostruct_to_hash(v) }
      when Array then object.map { |i| ostruct_to_hash(i) }
      when Hash
        object.transform_keys(&:to_s)
          .transform_values { |v| ostruct_to_hash(v) }
      else
        object
      end
    end
  end
end
