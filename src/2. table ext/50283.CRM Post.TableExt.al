tableextension 50283 tableextension50283 extends "CRM Post"
{
    fields
    {
        modify(RegardingObjectId)
        {
            TableRelation = IF (RegardingObjectTypeCode = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (RegardingObjectTypeCode = CONST(account)) "CRM Account".AccountId
            ELSE
            IF (RegardingObjectTypeCode = CONST(contact)) "CRM Contact".ContactId
            ELSE
            IF (RegardingObjectTypeCode = CONST(opportunity)) "CRM Opportunity".OpportunityId
            ELSE
            IF (RegardingObjectTypeCode = CONST(post)) "CRM Post".PostId
            ELSE
            IF (RegardingObjectTypeCode = CONST(transactioncurrency)) "CRM Transactioncurrency".TransactionCurrencyId
            ELSE
            IF (RegardingObjectTypeCode = CONST(pricelevel)) "CRM Pricelevel".PriceLevelId
            ELSE
            IF (RegardingObjectTypeCode = CONST(productpricelevel)) "CRM Productpricelevel".ProductPriceLevelId
            ELSE
            IF (RegardingObjectTypeCode = CONST(product)) "CRM Product".ProductId
            ELSE
            IF (RegardingObjectTypeCode = CONST(incident)) "CRM Incident".IncidentId
            ELSE
            IF (RegardingObjectTypeCode = CONST(incidentresolution)) "CRM Incidentresolution".ActivityId
            ELSE
            IF (RegardingObjectTypeCode = CONST(quote)) "CRM Quote".QuoteId
            ELSE
            IF (RegardingObjectTypeCode = CONST(quotedetail)) "CRM Quotedetail".QuoteDetailId
            ELSE
            IF (RegardingObjectTypeCode = CONST(salesorder)) "CRM Salesorder".SalesOrderId
            ELSE
            IF (RegardingObjectTypeCode = CONST(salesorderdetail)) "CRM Salesorderdetail".SalesOrderDetailId
            ELSE
            IF (RegardingObjectTypeCode = CONST(invoice)) "CRM Invoice".InvoiceId
            ELSE
            IF (RegardingObjectTypeCode = CONST(invoicedetail)) "CRM Invoicedetail".InvoiceDetailId
            ELSE
            IF (RegardingObjectTypeCode = CONST(contract)) "CRM Contract".ContractId
            ELSE
            IF (RegardingObjectTypeCode = CONST(team)) "CRM Team".TeamId
            ELSE
            IF (RegardingObjectTypeCode = CONST(customeraddress)) "CRM Customeraddress".CustomerAddressId
            ELSE
            IF (RegardingObjectTypeCode = CONST(uom)) "CRM Uom".UoMId
            ELSE
            IF (RegardingObjectTypeCode = CONST(uomschedule)) "CRM Uomschedule".UoMScheduleId
            ELSE
            IF (RegardingObjectTypeCode = CONST(organization)) "CRM Organization".OrganizationId
            ELSE
            IF (RegardingObjectTypeCode = CONST(businessunit)) "CRM Businessunit".BusinessUnitId
            ELSE
            IF (RegardingObjectTypeCode = CONST(discount)) "CRM Discount".DiscountId
            ELSE
            IF (RegardingObjectTypeCode = CONST(discounttype)) "CRM Discounttype".DiscountTypeId;
        }
        modify(RegardingObjectOwnerId)
        {
            TableRelation = IF (RegardingObjectOwnerIdType = CONST(systemuser)) "CRM Systemuser".SystemUserId
            ELSE
            IF (RegardingObjectOwnerIdType = CONST(team)) "CRM Team".TeamId;
        }
    }
}

