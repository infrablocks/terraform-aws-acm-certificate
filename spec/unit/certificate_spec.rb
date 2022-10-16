# frozen_string_literal: true

require 'spec_helper'

describe 'certificate' do
  let(:domain_name) do
    var(role: :root, name: 'domain_name')
  end

  let(:subject_alternative_names) do
    var(role: :root, name: 'subject_alternative_names')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a certificate' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate'))
    end

    it 'uses the provided domain name for the certificate' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate')
              .with_attribute_value(:domain_name, domain_name))
    end

    it 'uses the provided subject alternative names for the certificate' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate')
              .with_attribute_value(
                :subject_alternative_names, include(*subject_alternative_names)
              ))
    end

    it 'uses DNS validation for the certificate' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate')
              .with_attribute_value(:validation_method, 'DNS'))
    end
  end
end
