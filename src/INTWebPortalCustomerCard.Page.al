page 81232 "INT Web Portal-Customer Card"
{
    // version WebPortal

    Editable = false;
    PageType = Card;
    SourceTable = Customer;
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
                    ToolTip = 'Specifies the customer''s city.';
                }
                field(County; Rec.County)
                {
                    ApplicationArea = All;
                    Caption = 'County';
                    ToolTip = 'Specifies the state, province or county as a part of the address.';
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
                    ToolTip = 'Specifies the name of the person you regularly contact when you do business with this customer.';
                }
                field("Salesperson Code"; Rec."Salesperson Code")
                {
                    ApplicationArea = All;
                    Caption = 'Salesperson Code';
                    ToolTip = 'Specifies a code for the salesperson who normally handles this customer''s account.';
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                    ApplicationArea = All;
                    Caption = 'Responsibility Center';
                    ToolTip = 'Specifies the code for the responsibility center that will administer this customer by default.';
                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    Caption = 'Phone No.';
                    ToolTip = 'Specifies the customer''s telephone number.';
                }
                field("E-Mail"; Rec."E-Mail")
                {
                    ApplicationArea = All;
                    Caption = 'Email';
                    ToolTip = 'Specifies the customer''s email address.';
                }
                field("Home Page"; Rec."Home Page")
                {
                    ApplicationArea = All;
                    Caption = 'Home Page';
                    ToolTip = 'Specifies the customer''s home page address.';
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
        area(Navigation)
        {
            action("Test Report Prints")
            {
                ApplicationArea = All;
                Caption = 'Test Report Prints';
                Image = TestFile;
                ToolTip = 'Executes the Test Report Prints action.';
                Visible = true;

                trigger OnAction()
                var
                    CU: Codeunit "INT Web Portal Report (Email)";
                begin
                    Clear(CU);
                    // CU.PrintPostedSalesInvoice_gFnc('PS-INV103004', 'nishit@intech-systems.com');
                    // CU.PrintPostedSalesCreditNote_gFnc('PS-CR104001', 'nishit@intech-systems.com');
                    // CU.PrintSalesOrder_gFnc('S-ORD101004', 'nishit@intech-systems.com');
                    // CU.PrintPostedPurchDebitNote_gFnc('109001', 'nishit@intech-systems.com');
                    // CU.PrintPurchaseOrder_gFnc('106001', 'nishit@intech-systems.com');
                    //CU.PrintCustomerStatement_gFnc('50000', 20120101D, Today(), 'nishit@intech-systems.com');
                    // CU.PrintCustomerStatementExcel_gFnc('50000', 20120101D, Today(), 'nishit@intech-systems.com');
                    // CU.PrintVendorStatement_gFnc('50000', 20120101D, Today(), 'nishit@intech-systems.com');
                    // CU.PrintPendingSalesInvoice_gFnc('S-INV102205', 'nishit@intech-systems.com');
                    // CU.PrintPostedPurchInvoice_gFnc('108005', 'nishit@intech-systems.com');
                    // CU.PrintPostedPurchRcpt_gFnc('107005', 'nishit@intech-systems.com');
                    //CU.PrintCustomerPayments_gFnc('PS-INV103006', 'nishit@intech-systems.com');
                    // CU.PrintVendorPayments_gFnc('108002', 'nishit@intech-systems.com');
                end;
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

