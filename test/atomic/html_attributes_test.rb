require "test_helper"

module Atomic
  class HtmlAttributesTest < ActiveSupport::TestCase
    test "#with_token_list_defaults merges multiple attributes" do
      html_attributes = HtmlAttributes.new(class: ["a"], "data-attr": "a")

      attributes = html_attributes.with_token_list_defaults(class: "b", "data-attr": ["b"])

      assert_equal({ class: ["a", "b"], "data-attr": ["a", "b"] }, attributes)
    end

    test "#with_token_list_defaults de-duplicates tokens from a String" do
      html_attributes = HtmlAttributes.new(class: "a")

      attributes = html_attributes.with_token_list_defaults(class: "a")

      assert_equal({ class: ["a"] }, attributes)
    end

    test "#with_token_list_defaults de-duplicates tokens from an Array" do
      html_attributes = HtmlAttributes.new(class: ["a"])

      attributes = html_attributes.with_token_list_defaults(class: ["a"])

      assert_equal({ class: ["a"] }, attributes)
    end

    test "#with_token_list_defaults de-duplicates tokens from an Array of multi-token Strings" do
      html_attributes = HtmlAttributes.new(class: "a b")

      attributes = html_attributes.with_token_list_defaults(class: ["a"])

      assert_equal({ class: ["a", "b"] }, attributes)
    end
  end
end
