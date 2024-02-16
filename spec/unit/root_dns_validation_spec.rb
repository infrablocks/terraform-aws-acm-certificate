# frozen_string_literal: true

require 'spec_helper'

describe 'root module DNS validation' do
  let(:domain_name) do
    var(role: :root, name: 'domain_name')
  end

  let(:subject_alternative_names) do
    var(role: :root, name: 'subject_alternative_names')
  end

  let(:zone_id) do
    var(role: :root, name: 'zone_id')
  end

  describe 'by default' do
    before(:context) do
      @plan = plan(role: :root)
    end

    it 'creates a DNS record for the provided domain name for ' \
       'certificate validation' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record',
                                      index: domain_name))
    end

    it 'uses the provided hosted zone for the domain name DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record',
                                      index: domain_name)
              .with_attribute_value(:zone_id, zone_id))
    end

    it 'uses a TTL of 60 for the domain name DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record',
                                      index: domain_name)
              .with_attribute_value(:ttl, 60))
    end

    it 'allows override for the domain name DNS record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record',
                                      index: domain_name)
              .with_attribute_value(:allow_overwrite, true))
    end

    it 'creates DNS records for each of the provided subject ' \
       'alternative names for certificate validation' do
      subject_alternative_names.each do |subject_alternative_name|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_route53_record',
                                        index: subject_alternative_name))
      end
    end

    it 'uses the provided hosted zone for the subject alternative name ' \
       'DNS records' do
      subject_alternative_names.each do |subject_alternative_name|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_route53_record',
                                        index: subject_alternative_name)
                .with_attribute_value(:zone_id, zone_id))
      end
    end

    it 'uses a TTL of 60 for the subject alternative name DNS records' do
      subject_alternative_names.each do |subject_alternative_name|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_route53_record',
                                        index: subject_alternative_name)
                .with_attribute_value(:ttl, 60))
      end
    end

    it 'allows override for the subject alternative name DNS records' do
      subject_alternative_names.each do |subject_alternative_name|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_route53_record',
                                        index: subject_alternative_name)
                .with_attribute_value(:allow_overwrite, true))
      end
    end

    it 'creates a certificate validation' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate_validation'))
    end
  end
end
