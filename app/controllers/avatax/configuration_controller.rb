# frozen_string_literal: true

require 'avatax/client'

module Avatax
  class ConfigurationController < EngineController
    def index
      @tax_codes = ::Killbill::Avatax::AvataxClient.get_tax_codes(options_for_klient)
      @exemptions = exempt_accounts
    end

    #
    # Tax Codes
    #

    def set_tax_code
      simple_catalog = KillBillClient::Model::Catalog.simple_catalog(nil, options_for_klient).last
      @products = simple_catalog ? simple_catalog.products.map(&:name) : []
    end

    def do_set_tax_code
      ::Killbill::Avatax::AvataxClient.set_tax_code(params.require(:product_name),
                                                    params.require(:tax_code),
                                                    options_for_klient[:username],
                                                    params[:reason],
                                                    params[:comment],
                                                    options_for_klient)

      flash[:notice] = 'Tax code successfully saved'
      redirect_to action: :index
    end

    def remove_tax_code
      ::Killbill::Avatax::AvataxClient.remove_tax_code(params.require(:product_name),
                                                       options_for_klient[:username],
                                                       params[:reason],
                                                       params[:comment],
                                                       options_for_klient)

      flash[:notice] = 'Tax code successfully removed'
      redirect_to action: :index
    end

    #
    # Exemptions
    #

    def set_exemption; end

    def do_set_exemption
      ::Killbill::Avatax::AvataxClient.set_exemption(params.require(:account_id),
                                                     params.require(:customer_usage_type),
                                                     options_for_klient[:username],
                                                     params[:reason],
                                                     params[:comment],
                                                     options_for_klient)

      flash[:notice] = 'Exemption successfully saved'
      redirect_to action: :index
    end

    def remove_exemption
      ::Killbill::Avatax::AvataxClient.remove_exemption(params.require(:account_id),
                                                        options_for_klient[:username],
                                                        params[:reason],
                                                        params[:comment],
                                                        options_for_klient)

      flash[:notice] = 'Exemption successfully removed'
      redirect_to action: :index
    end

    #
    # Settings
    #

    def plugin_configuration
      @configuration = {}

      config = KillBillClient::Model::Tenant.get_tenant_plugin_config('killbill-avatax', options_for_klient)
      return if config.values.empty?

      config.values.first.split.each do |property|
        k, v = property.split('=')
        case k
        when 'org.killbill.billing.plugin.avatax.accountId'
          @configuration[:account_id] = v
        when 'org.killbill.billing.plugin.avatax.licenseKey'
          @configuration[:license_key] = v
        when 'org.killbill.billing.plugin.avatax.companyCode'
          @configuration[:company_code] = v
        when 'org.killbill.billing.plugin.avatax.commitDocuments'
          @configuration[:commit_documents] = v == 'true'
        end
      end
    end

    def update_plugin_configuration
      plugin_config = "org.killbill.billing.plugin.avatax.accountId=#{params.require(:account_id)}
org.killbill.billing.plugin.avatax.licenseKey=#{params.require(:license_key)}\n"
      plugin_config << "org.killbill.billing.plugin.avatax.commitDocuments=#{params[:commit_documents] == '1'}\n"
      plugin_config << "org.killbill.billing.plugin.avatax.companyCode=#{params[:company_code]}\n" unless params[:company_code].blank?

      # Merge the new values with the current config. The config will likely contain additional fields that we don't want to clobber.
      # The user should really use the more powerful /admin_tenants screen - this plugin screen was just created
      # to be able to pass the initial AvaTax certification.
      current_config = KillBillClient::Model::Tenant.get_tenant_plugin_config('killbill-avatax', options_for_klient)
      config_values = current_config.values
      config_values.present? && config_values.first.split.each do |property|
        k, v = property.split('=')
        plugin_config << case k
                         when 'org.killbill.billing.plugin.avatax.accountId', 'org.killbill.billing.plugin.avatax.licenseKey', 'org.killbill.billing.plugin.avatax.companyCode', 'org.killbill.billing.plugin.avatax.commitDocuments'
                           next
                         else
                           "#{k}=#{v}\n"
                         end
      end

      KillBillClient::Model::Tenant.upload_tenant_plugin_config('killbill-avatax',
                                                                plugin_config,
                                                                options_for_klient[:username],
                                                                params[:reason],
                                                                params[:comment],
                                                                options_for_klient)

      flash[:notice] = 'Configuration successfully saved'
      redirect_to action: :index
    end

    private

    def exempt_accounts(offset = 0, limit = 100)
      custom_field_value = 'customerUsageType'

      KillBillClient::Model::CustomField.find_in_batches_by_search_key(custom_field_value, offset, limit, options_for_klient)
                                        .select { |cf| cf.name == custom_field_value && cf.object_type == 'ACCOUNT' }
                                        .map { |cf| { account_id: cf.object_id, customer_usage_type: cf.value } }
    end

    def options_for_klient
      user = current_tenant_user
      {
        username: user[:username],
        password: user[:password],
        session_id: user[:session_id],
        api_key: user[:api_key],
        api_secret: user[:api_secret]
      }
    end
  end
end
