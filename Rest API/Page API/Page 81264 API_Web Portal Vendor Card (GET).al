page 81264 "API_Web Portal Vendor Card"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiWebPortalVendorCard';
    DelayedInsert = true;
    EntityName = 'apiWebPortalVendorCard';
    EntityCaption = 'apiWebPortalVendorCard';
    EntitySetName = 'apiWebPortalVendorCards';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiWebPortalVendorCards';
    PageType = API;
    SourceTable = Vendor;

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
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field(address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the vendor''s address.';
                }
                field("address2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies additional address information.';
                }
                field(city; Rec.City)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the vendor''s city.';
                }
                field(county; Rec.County)
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
                }
                field("postCode"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code';
                    ToolTip = 'Specifies the postal code.';
                }
                field("countryRegionCode"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region Code';
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';
                }
                field(purchaserCode; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Caption = 'Purchaser Code';
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field("responsibilityCenter"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Caption = 'Responsibility Center';
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("phoneNo"; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field("eMail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Specifies the vendor''s email address.';
                }
                field("homePage"; Rec."Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page';
                    ToolTip = 'Specifies the vendor''s web site.';
                }
                field("paymentTerms"; PaymentTermsDesc_gTxt)
                {
                    ApplicationArea = All;
                    Caption = 'PaymentTermsDesc_gTxt';
                    Editable = false;
                    ToolTip = 'Specifies the value of the PaymentTermsDesc_gTxt field.';
                }
                field(salesPersonName_gTxt; SalesPersonName_gTxt)
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
        if SalespersonPurchaser_gRec.Get(Rec."Purchaser Code") then
            SalesPersonName_gTxt := SalespersonPurchaser_gRec.Name;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
    end;

    var
        PaymentTerms_gRec: Record "Payment Terms";
        SalespersonPurchaser_gRec: Record "Salesperson/Purchaser";
        PaymentTermsDesc_gTxt: Text;
        SalesPersonName_gTxt: Text;
}