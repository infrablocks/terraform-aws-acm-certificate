# frozen_string_literal: true

require 'spec_helper'

describe 'validations module record resources' do
  let(:zone_id) do
    var(role: :validations, name: 'zone_id')
  end

  describe 'when no records provided' do
    before(:context) do
      @plan = plan(role: :validations) do |vars|
        vars.records = []
      end
    end

    it 'does not create any records' do
      expect(@plan)
        .not_to(include_resource_creation(type: 'aws_route53_record'))
    end
  end

  describe 'when one record provided' do
    before(:context) do
      @resource_record_name = '_35f52d622972095bda9584ec277d5963.example.com.'
      @resource_record_type = 'CNAME'
      @resource_record_value =
        '_483b64e943c369e10ea114f838c629f3.mhbtsbpdnt.acm-validations.aws.'

      @plan = plan(role: :validations) do |vars|
        vars.records = [
          {
            domain_name: 'example.com',
            resource_record_name: @resource_record_name,
            resource_record_type: @resource_record_type,
            resource_record_value: @resource_record_value
          }
        ]
      end
    end

    it 'creates one validation record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .once)
    end

    it 'uses the correct name on the validation record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(
                :name,
                @resource_record_name.sub(/\.$/, '')
              ))
    end

    it 'uses the correct type on the validation record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:type, @resource_record_type))
    end

    it 'uses the correct value on the validation record' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .with_attribute_value(:records, [@resource_record_value]))
    end
  end

  describe 'when many unique records provided' do
    before(:context) do
      @records = [
        {
          domain_name: 'zeroth-example.com',
          resource_record_name:
            '_35f52d622972095bda9584ec277d5963.example.com.',
          resource_record_type: 'CNAME',
          resource_record_value:
            '_483b64e943c369e10ea114f838c629f3.mhbtsbpdnt.acm-validations.aws.'
        },
        {
          domain_name: '*.first-example.com',
          resource_record_name:
            '_75316205fe3174d45508b102626e30f5.logicblocks.io.',
          resource_record_type: 'CNAME',
          resource_record_value:
            '_1f90fe28e3e277fcf9709d818e559552.mhbtsbpdnt.acm-validations.aws.'
        },
        {
          domain_name: '*.second-example.com',
          resource_record_name:
            '_45e51c622972095bda9584ec277e6774.example.com.',
          resource_record_type: 'CNAME',
          resource_record_value:
            '_5466fe7943c369e10ea114f838c32e45.mhbtsbpdnt.acm-validations.aws.'
        }
      ]

      @plan = plan(role: :validations) do |vars|
        vars.records = @records
      end
    end

    it 'creates many validation records' do
      expect(@plan)
        .to(include_resource_creation(type: 'aws_route53_record')
              .thrice)
    end

    it 'uses the correct details on the validation records' do
      @records.each do |record|
        expect(@plan)
          .to(include_resource_creation(type: 'aws_route53_record')
                .with_attribute_value(
                  :name,
                  record[:resource_record_name].sub(/\.$/, '')
                )
                .with_attribute_value(
                  :type,
                  record[:resource_record_type]
                )
                .with_attribute_value(
                  :records,
                  [record[:resource_record_value]]
                ))
      end
    end
  end
end
