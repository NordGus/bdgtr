class FormGenerator < Rails::Generators::NamedBase
  source_root File.expand_path("templates", __dir__)

  argument :attributes, type: :array, default: [], banner: "attribute[:type] attribute[:type]"

  def create_form_model
    template "form.rb.tt", "app/forms/#{file_path}_form.rb"
  end

  def create_form_model_test
    template "form_test.rb.tt", "test/forms/#{file_path}_form_test.rb"
  end
end
