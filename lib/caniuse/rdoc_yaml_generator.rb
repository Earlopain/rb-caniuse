# frozen_string_literal: true

module Caniuse
  class RDocYAMLGenerator
    ::RDoc::RDoc.add_generator self

    def initialize(store, options)
      @store = store
      @options = options
    end

    def generate # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      result = {}
      @store.all_classes_and_modules.each do |class_module|
        # RDoc::ClassModule
        result[class_module.full_name] ||= {}
        result[class_module.full_name][:attrs] = class_module.attributes.map do |attr|
          # RDoc::Attr
          { name: attr.name, rw: attr.rw, singleton: attr.singleton, visibility: attr.visibility }
        end
        result[class_module.full_name][:methods] = class_module.method_list.map do |method|
          # RDoc::AnyMethod
          { name: method.name, params: method.params, singleton: method.singleton, visibility: method.visibility }
        end
        result[class_module.full_name][:consts] = class_module.constants.map do |constant|
          # RDoc::Constant
          { name: constant.name, visibility: constant.visibility }
        end
      end
      File.write("#{@options.op_dir}/data.yml", result.to_yaml)
    end
  end
end
