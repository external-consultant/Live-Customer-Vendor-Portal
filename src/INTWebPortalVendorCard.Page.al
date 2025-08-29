page 81235 "INT Web Portal - Vendor Card"
{
    // version WebPortal

    Caption = 'Vendor Details';
    Editable = false;
    PageType = Card;
    SourceTable = Vendor;
    SourceTableView = sorting("No.");

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';
                    ToolTip = 'Specifies the vendor''s name. You can enter a maximum of 30 characters, both numbers and letters.';
                }
                field(Address; Rec.Address)
                {
                    ApplicationArea = All;
                    Caption = 'Address';
                    ToolTip = 'Specifies the vendor''s address.';
                }
                field("Address 2"; Rec."Address 2")
                {
                    ApplicationArea = All;
                    Caption = 'Address 2';
                    ToolTip = 'Specifies additional address information.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    Caption = 'City';
                    ToolTip = 'Specifies the vendor''s city.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
                }
                field("Post Code"; Rec."Post Code")
                {
                    ApplicationArea = All;
                    Caption = 'Post Code';
                    ToolTip = 'Specifies the postal code.';
                }
                field("Country/Region Code"; Rec."Country/Region Code")
                {
                    ApplicationArea = All;
                    Caption = 'Country/Region Code';
                    ToolTip = 'Specifies the country/region of the address.';
                }
                field(Contact; Rec.Contact)
                {
                    ApplicationArea = All;
                    Caption = 'Contact';
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this vendor.';
                }
                field("Purchaser Code"; Rec."Purchaser Code")
                {
                    ApplicationArea = All;
                    Caption = 'Purchaser Code';
                    ToolTip = 'Specifies which purchaser is assigned to the vendor.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Caption = 'Responsibility Center';
                    ToolTip = 'Specifies the code of the responsibility center, such as a distribution hub, that is associated with the involved user, company, customer, or vendor.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the vendor''s telephone number.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Specifies the vendor''s email address.';
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page';
                    ToolTip = 'Specifies the vendor''s web site.';
                }
                field("Payment Terms"; PaymentTermsDesc_gTxt)
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

    actions
    {
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

