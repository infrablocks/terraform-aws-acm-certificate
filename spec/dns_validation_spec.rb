require 'spec_helper'

describe 'DNS validation' do
  let(:zone_id) { vars.zone_id }
  let(:domain_validations) {
    output_for(:harness, 'domain_validations')
  }

  subject {
    route53_hosted_zone(zone_id)
  }

  it "has records for each required domain validation" do
    domain_validations.each do |domain_validation|
      expect(subject)
          .to(have_record_set(domain_validation[:record_name])
              .cname(domain_validation[:record_value]))
    end
  end
end
