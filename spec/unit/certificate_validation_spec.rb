# frozen_string_literal: true

require 'spec_helper'

describe 'certificate module certificate validation resource' do
  describe 'by default' do
    before(:context) do
      @plan = plan(role: :certificate)
    end

    it 'creates a certificate validation' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate_validation'))
    end
  end

  describe 'when wait_for_validation is false' do
    before(:context) do
      @plan = plan(role: :certificate) do |vars|
        vars.wait_for_validation = false
      end
    end

    it 'does not create a certificate validation' do
      expect(@plan)
        .not_to(
          include_resource_creation(type: 'aws_acm_certificate_validation'))
    end
  end

  describe 'when wait_for_validation is true' do
    before(:context) do
      @plan = plan(role: :certificate) do |vars|
        vars.wait_for_validation = true
      end
    end

    it 'creates a certificate validation' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_acm_certificate_validation'))
    end
  end
end

