codeunit 81235 "INT Web Portal -Create WebServ"
{
    // version WebPortal

    trigger OnRun()
    begin
        Create();
        Message('Web Service Created Successfully');
    end;

    var
        ObjectType_gOpt: Option ,,,,,Codeunit,,,Page,Query;

    local procedure CreateWebService_lFnc(ObjectType_iOpt: Option ,,,,,Codeunit,,,Page,Query; ObjectID_iInt: Integer; ServiceName_iTxt: Text[240]; Published_iBln: Boolean)
    var
        TenantWebservice_lRec: Record "Tenant Web Service";
    begin
        Clear(TenantWebservice_lRec);
        if TenantWebservice_lRec.Get(ObjectType_iOpt, ServiceName_iTxt) then begin
            TenantWebservice_lRec.Validate("Object Type", ObjectType_iOpt);
            TenantWebservice_lRec.Validate("Object ID", ObjectID_iInt);
            TenantWebservice_lRec.Validate("Service Name", ServiceName_iTxt);
            TenantWebservice_lRec.Validate(Published, Published_iBln);
            TenantWebservice_lRec.Modify(true);
        end else begin
            TenantWebservice_lRec.Init();
            TenantWebservice_lRec.Validate("Object Type", ObjectType_iOpt);
            TenantWebservice_lRec.Validate("Object ID", ObjectID_iInt);
            TenantWebservice_lRec.Validate("Service Name", ServiceName_iTxt);
            TenantWebservice_lRec.Validate(Published, Published_iBln);
            TenantWebservice_lRec.Insert(true);
        end;
    end;

    procedure Create()
    begin
        CreateWebService_lFnc(ObjectType_gOpt::Codeunit, Codeunit::"INT Web Portal - Login Mgmt", 'WebPortalLoginMgmt', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT Web Portal-Customer Card", 'WebPortalCustomerCard', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT Web-Posted Cred.Note", 'WebPortalPostedCreditNote', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT Web Portal-Posted Invoice", 'WebPortalPostedInvoice', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Customer Payments", 'WebPortalCustomerPayments', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT -Check Information", 'WebPortalCheckInformation', true);
        CreateWebService_lFnc(ObjectType_gOpt::Codeunit, Codeunit::"INT Web Portal - Check Mgmt", 'WebPortalCheckMgt', true);
        CreateWebService_lFnc(ObjectType_gOpt::Codeunit, Codeunit::"INT Web Portal - Statistics", 'WebPortalStatistics', true);
        CreateWebService_lFnc(ObjectType_gOpt::Codeunit, Codeunit::"INT Web Portal Report (Email)", 'WebPortalReportPrints', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Notification", 'WebPortalNotification', true);
        CreateWebService_lFnc(ObjectType_gOpt::Codeunit, Codeunit::"INT Web Portal-Notif Mgt", 'WebPortalNotificationMgt', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT WebPortal Item List", 'WebPortalItemList', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Pending Sales Inv.", 'WebPortalPendingSalesInv', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"Company Information", 'CompanyInformation', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Overdue Delivery", 'WebPortalOverdueDelivery', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT Web Portal - Vendor Card", 'WebPortalVendorCard', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT Web Portal-Pend Purch Ord", 'WebPortalPendingPurchOrder', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Posted Purch Rcpt", 'WebPortalPostedPurchRcpt', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Pending Purch Inv.", 'WebPortalPendingPurchInv', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Posted Debit Note", 'WebPortalPostedDebitNote', true);
        CreateWebService_lFnc(ObjectType_gOpt::Page, Page::"INT - Vendor Payments", 'WebPortalVendorPayments', true);
    end;
}

