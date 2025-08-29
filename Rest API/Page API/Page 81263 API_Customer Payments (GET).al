page 81263 "API_Customer Payments"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiCustomerPayment';
    DelayedInsert = true;
    EntityName = 'apiCustomerPayment';
    EntityCaption = 'apiCustomerPayment';
    EntitySetName = 'apiCustomerPayments';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiCustomerPayments';
    PageType = API;
    SourceTable = "Cust. Ledger Entry";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(entryNo; Rec."Entry No.")
                {
                    ApplicationArea = All;
                    Caption = 'Entry No.';
                    ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                }
                field(customerNo; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Caption = 'Customer No.';
                    ToolTip = 'Specifies the customer account number that the entry is linked to.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the customer entry''s posting date.';
                }
                field(documentType; Rec."Document Type")
                {
                    ApplicationArea = All;
                    Caption = 'Document Type';
                    ToolTip = 'Specifies the document type that the customer entry belongs to.';
                }
                field(documentNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the entry''s document number.';
                }
                field(externalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'External Document No.';
                    ToolTip = 'Specifies a document number that refers to the customer''s or vendor''s numbering system.';
                }
                field(amount; Rec.Amount)
                {
                    ApplicationArea = All;
                    Caption = 'Amount';
                    ToolTip = 'Specifies the amount of the entry.';
                }
                field(amountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = All;
                    Caption = 'Amount (LCY)';
                    ToolTip = 'Specifies the amount of the entry in LCY.';
                }
                field(globalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Global Dimension 1 Code';
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field(globalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Caption = 'Global Dimension 2 Code';
                    ToolTip = 'Specifies the code for the global dimension that is linked to the record or entry for analysis purposes. Two global dimensions, typically for the company''s most important activities, are available on all cards, documents, reports, and lists.';
                }
                field(debitAmount; Rec."Debit Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Debit Amount';
                    ToolTip = 'Specifies the total of the ledger entries that represent debits.';
                }
                field(creditAmount; Rec."Credit Amount")
                {
                    ApplicationArea = All;
                    Caption = 'Credit Amount';
                    ToolTip = 'Specifies the total of the ledger entries that represent credits.';
                }
                field(recordCount; RecCnt_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Record Count field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        RecCnt_gInt += 1;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Customer No.") = '' THEN
            ERROR('Apply Customer filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        RecCnt_gInt: Integer;
}

