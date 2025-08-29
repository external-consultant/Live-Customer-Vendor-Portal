page 81294 "API_Customer_Payments"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCustomerPayments';
    DelayedInsert = true;
    EntityName = 'apiCustomerPayments';
    EntityCaption = 'apiCustomerPayments';
    EntitySetName = 'apiCustomerPaymentss';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCustomerPaymentss';
    PageType = API;
    SourceTable = "Cust. Ledger Entry";
    SourceTableView = where("Document Type" = filter(Payment), Reversed = const(false));

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(customerNo; Rec."Customer No.")
                {
                    Caption = 'Customer No.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    Caption = 'Posting Date';
                }
                field(documentNo; Rec."Document No.")
                {
                    Caption = 'Document No.';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field(paymentReference; Rec."Payment Reference")
                {
                    Caption = 'Payment Reference';
                }
                field(currencyCode; CurrencyCode_gCode)
                {
                    Caption = 'Currency Code';
                }
                field(CheckNo_gCode; CheckNo_gCode)
                {
                    Caption = 'Check No';
                }
                field(CehckDate_gDate; CehckDate_gTxt)
                {
                    Caption = 'Check Date';
                }
                field(totalTCSIncludingSHECESS; Rec."Total TCS Including SHE CESS")
                {
                    Caption = 'Total TCS Including SHE CESS';
                }
                // field(totalTDSIncludingSHECESS; Rec."Total TDS Including SHE CESS")
                // {
                //     Caption = 'Total TDS Including SHE CESS';
                // }
                field(amount; amountPosResponse_gDec)
                {
                    Caption = 'Amount';
                }
                field(negativeamount; Rec.Amount)
                {

                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        GenralLedgSetup_lRec: Record "General Ledger Setup";
        BankACCLedEntry_lRec: Record "Bank Account Ledger Entry";
    begin
        Clear(CurrencyCode_gCode);
        Clear(CheckNo_gCode);
        Clear(CehckDate_gTxt);

        if Rec."Currency Code" = '' then begin
            GenralLedgSetup_lRec.Get();
            CurrencyCode_gCode := GenralLedgSetup_lRec."LCY Code";
        end else begin
            CurrencyCode_gCode := Rec."Currency Code";
        end;

        if Rec."Bal. Account Type" = Rec."Bal. Account Type"::"Bank Account" then begin
            BankACCLedEntry_lRec.Reset();

            BankACCLedEntry_lRec.SetRange("Document No.", Rec."Document No.");
            BankACCLedEntry_lRec.SetRange("Posting Date", Rec."Posting Date");
            if BankACCLedEntry_lRec.FindFirst() then begin
                CheckNo_gCode := BankACCLedEntry_lRec."Cheque No.";
                Clear(CehckDate_gTxt);
                CehckDate_gTxt := '';
                if BankACCLedEntry_lRec."Cheque Date" <> 0D then begin
                    CehckDate_gTxt := Format(BankACCLedEntry_lRec."Cheque Date");
                end;
            end;
        end;

        amountPosResponse_gDec := Rec.Amount * -1;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();
        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

    end;

    var
        CheckNo_gCode: Code[20];
        CehckDate_gTxt: Text;
        CheckDate_gDate: Date;
        CDateDay_gInt, CdateYear_gInt, CdateMonth_gInt : Integer;
        CurrencyCode_gCode: Code[10];
        amountPosResponse_gDec: Decimal;


}
