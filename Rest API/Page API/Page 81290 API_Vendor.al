page 81290 "API_Vendor"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiVendor';
    DelayedInsert = true;
    EntityName = 'apiVendor';
    EntityCaption = 'apiVendor';
    EntitySetName = 'apiVendors';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiVendors';
    PageType = API;
    SourceTable = Vendor;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    Caption = 'No.';
                }
                field(name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(name2; Rec."Name 2")
                {
                    Caption = 'Name 2';
                }
                field(mobilePhoneNo; Rec."Mobile Phone No.")
                {
                    Caption = 'Mobile Phone No.';
                }
                field(address; Rec.Address)
                {
                    Caption = 'Address';
                }
                field(address2; Rec."Address 2")
                {
                    Caption = 'Address 2';
                }
                field(balance; Rec.Balance)
                {
                    Caption = 'Balance';
                }
                field(balanceLCY; Rec."Balance (LCY)")
                {
                    Caption = 'Balance (LCY)';
                }
                field(city; Rec.City)
                {
                    Caption = 'City';
                }
                field(postCode; Rec."Post Code")
                {
                    Caption = 'Post Code';
                }
                field(payments; Rec."Payments (LCY)")
                {
                    Caption = 'Payments';
                }
                field(amtRcdNotInvoiced; Rec."Amt. Rcd. Not Invoiced (LCY)")
                {
                    Caption = 'Amt. Rcd. Not Invoiced';
                }
                field(outstandingOrders; Rec."Outstanding Rel Order (LCY)")
                {
                    Caption = 'Outstanding Orders';
                }
                field(balanceDue; Rec."Balance Due (LCY)")
                {
                    Caption = 'Balance Due';
                }
                field(gstVendorType; Rec."GST Vendor Type")
                {
                    Caption = 'GST Vendor Type';
                }
                field(gstRegistrationNo; Rec."GST Registration No.")
                {
                    Caption = 'GST Registration No.';
                }
                field(pANNo; Rec."P.A.N. No.")
                {
                    Caption = 'P.A.N. No.';
                }
                field(image; Rec.Image)
                {
                    Caption = 'Image';
                }
                field(PurchaserName_gTxt; PurchaserName_gTxt)
                {

                }
                field(Country_gTxt; Country_gTxt)
                {

                }
                field(Assessee_gTxt; Assessee_gTxt)
                {

                }
                field(ResponsibilityCenter_gTxt; ResponsibilityCenter_gTxt)
                {

                }
                field(Paymentterms_gTxt; Paymentterms_gTxt)
                {

                }
                field(eMail; Rec."E-Mail")
                {
                    Caption = 'Email';
                }
                field(homePage; Rec."Home Page")
                {
                    Caption = 'Home Page';
                }
                field(GLSLcyCode; GLSLcyCode)
                {
                    ApplicationArea = All;
                }
                field(GLSLocalCurrencySymbol_gTxt; GLSLocalCurrencySymbol_gTxt)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        BankACCLedEntry_lRec: Record "Bank Account Ledger Entry";
        Paymentterms_lRec: Record "Payment Terms";
        SalesPeople_lRec: Record "Salesperson/Purchaser";
        CountryRegion_lRec: Record "Country/Region";
        Assessee_lRec: Record "Assessee Code";
        ResponsibilityCenter_lRec: Record "Responsibility Center";
        InStr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
        GeneralLedgerSetup_lRec: Record "General Ledger Setup";
    begin

        Rec.CalcFields(Balance);
        Rec.CalcFields("Balance (LCY)");
        // Rec.CalcFields("Outstanding Orders (LCY)");
        Rec.CalcFields("Amt. Rcd. Not Invoiced (LCY)");
        Rec.CalcFields("Payments (LCY)");
        Rec.CalcFields("Outstanding Rel Order (LCY)");

        Clear(PurchaserName_gTxt);
        Clear(ResponsibilityCenter_gTxt);
        clear(Country_gTxt);
        Clear(Assessee_gTxt);
        Clear(Paymentterms_gTxt);

        if Rec."Payment Terms Code" <> '' then begin
            Paymentterms_lRec.Reset();
            if Paymentterms_lRec.Get(Rec."Payment Terms Code") then begin
                Paymentterms_gTxt := Paymentterms_lRec.Description;
            end;
        end;

        if Rec."Purchaser Code" <> '' then begin
            SalesPeople_lRec.Reset();
            if SalesPeople_lRec.Get(Rec."Purchaser Code") then begin
                PurchaserName_gTxt := SalesPeople_lRec.Name;
            end;
        end;

        if Rec."Assessee Code" <> '' then begin
            Assessee_lRec.Reset();
            if Assessee_lRec.Get(Rec."Assessee Code") then begin
                Assessee_gTxt := Assessee_lRec.Code;
            end;
        end;

        if Rec."Responsibility Center" <> '' then begin
            ResponsibilityCenter_lRec.Reset();
            if ResponsibilityCenter_lRec.Get(Rec."Responsibility Center") then begin
                ResponsibilityCenter_gTxt := ResponsibilityCenter_lRec.Name;
            end;
        end;


        if Rec."Country/Region Code" <> '' then begin
            CountryRegion_lRec.Reset();
            if CountryRegion_lRec.Get(Rec."Country/Region Code") then begin
                Country_gTxt := CountryRegion_lRec.Name;
            end;
        end;

        // ProfilePicture_gTxt := '';
        // Rec.CalcFields(Image);
        // Format(Rec."Image").CreateInStream(InStr);
        // ProfilePicture_gTxt := Base64Convert.ToBase64(InStr);


        GeneralLedgerSetup_lRec.Reset();
        GeneralLedgerSetup_lRec.Get();
        GLSLocalCurrencySymbol_gTxt := GeneralLedgerSetup_lRec."Local Currency Symbol";
        GLSLcyCode := GeneralLedgerSetup_lRec."LCY Code";

    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        // Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

    end;

    var
        GLSLocalCurrencySymbol_gTxt: Text;
        GLSLcyCode: Code[20];
        PurchaserName_gTxt: Text;
        ResponsibilityCenter_gTxt: Text;
        Paymentterms_gTxt: Text;
        Country_gTxt: Text;
        Assessee_gTxt: Text;
        ProfilePicture_gTxt: Text;
}
