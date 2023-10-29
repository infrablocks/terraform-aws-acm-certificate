# frozen_string_literal: true

require 'spec_helper'

describe 'full' do
  before(:context) do
    apply(role: :full)
  end

  after(:context) do
    destroy(
      role: :full,
      only_if: -> { !ENV['FORCE_DESTROY'].nil? || ENV['SEED'].nil? }
    )
  end

  describe 'certificate' do
    subject do
      acm(domain_name)
    end

    let(:domain_name) do
      var(role: :full, name: 'domain_name')
    end

    let(:subject_alternative_names) do
      var(role: :full, name: 'subject_alternative_names')
    end

    it { is_expected.to exist }

    its(:subject_alternative_names) do
      is_expected
        .to(match_array(([domain_name] + subject_alternative_names)))
    end
  end

  describe 'DNS validation' do
    subject(:zone) do
      route53_hosted_zone(zone_id)
    end

    let(:zone_id) { var(role: :full, name: 'zone_id') }
    let(:domain_validations) { output(role: :full, name: 'domain_validations') }

    it 'has records for each required domain validation' do
      domain_validations.each do |domain_validation|
        expect(zone)
          .to(have_record_set(domain_validation[:record_name])
                .cname(domain_validation[:record_value]))
      end
    end
  end
end
