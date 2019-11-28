require 'spec_helper'

describe 'certificate' do
  let(:domain_name) { vars.domain_name }
  let(:subject_alternative_names) { vars.subject_alternative_names }

  subject {
    acm(domain_name)
  }

  it { should exist }
  its(:subject_alternative_names) do
    should contain_exactly(*([domain_name] + subject_alternative_names))
  end
end
