page 81258 "API_Web Portal-Customer Card"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalCustomerCard';
    DelayedInsert = true;
    EntityName = 'apiWebPortalCustomerCard';
    EntityCaption = 'apiWebPortalCustomerCard';
    EntitySetName = 'apiWebPortalCustomerCards';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiGetCustomerDetails';
    PageType = API;
    SourceTable = Customer;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the customer. The field is either filled automatically from a defined number series, or you enter the number manually because you have enabled manual number entry in the number-series setup.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the customer''s name.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the customer''s address. This address will appear on all sales documents for the customer.';
                }
                field(Address2; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies additional address information.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the customer''s city.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
                }
                field(CountryRegionCode; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region Code';
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson Code';
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Caption = 'Responsibility Center';
                    ToolTip = 'Specifies the code for the responsibility center that will administer this customer by default.';
                }
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field(EMail; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field(HomePage; Rec."Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page';
                    ToolTip = 'Specifies the customer''s home page address.';
                }
                field(PaymentTerms; PaymentTermsDesc_gTxt)
                {
                    ApplicationArea = All;
                    Caption = 'PaymentTermsDesc_gTxt';
                    Editable = false;
                    ToolTip = 'Specifies the value of the PaymentTermsDesc_gTxt field.';
                }
                field(SalesPersonName_gTxt; SalesPersonName_gTxt)
                {
                    ApplicationArea = All;
                    Caption = 'SalesPersonName_gTxt';
                    ToolTip = 'Specifies the value of the SalesPersonName_gTxt field.';
                }
            }
        }
    }


    trigger OnAfterGetRecord()
    begin
        PaymentTermsDesc_gTxt := '';
        if PaymentTerms_gRec.Get(Rec."Payment Terms Code") then
            PaymentTermsDesc_gTxt := PaymentTerms_gRec.Description;

        SalesPersonName_gTxt := '';
        if SalespersonPurchaser_gRec.Get(Rec."Salesperson Code") then
            SalesPersonName_gTxt := SalespersonPurchaser_gRec.Name;
    end;

    trigger OnOpenPage()
    var
    // INTKeyValidationMgt: Codeunit "INT Key Validation Mgt_";
    begin
        // Clear(INTKeyValidationMgt);
        // INTKeyValidationMgt.onOpenPageKeyValidation();

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("No.") = '' THEN
            ERROR('Apply Customer filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        PaymentTerms_gRec: Record "Payment Terms";
        SalespersonPurchaser_gRec: Record "Salesperson/Purchaser";
        PaymentTermsDesc_gTxt: Text;
        SalesPersonName_gTxt: Text;
}