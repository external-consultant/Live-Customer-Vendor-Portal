page 81268 "API_Posted Purch Rcpt"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiPostedPurchRcpt';
    DelayedInsert = true;
    EntityName = 'apiPostedPurchRcpt';
    EntityCaption = 'apiPostedPurchRcpt';
    EntitySetName = 'apiPostedPurchRcpts';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiPostedPurchRcpts';
    PageType = API;
    SourceTable = "Purch. Rcpt. Header";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of a general ledger account, item, additional cost, or fixed asset, depending on what you selected in the Type field.';
                }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(buyFromVendorName; Rec."Buy-from Vendor Name")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor Name';
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(postingDate; Rec."Posting Date")
                {
                    ApplicationArea = All;
                    Caption = 'Posting Date';
                    ToolTip = 'Specifies the posting date of the record.';
                }
                field(dueDate; Rec."Due Date")
                {
                    ApplicationArea = All;
                    Caption = 'Due Date';
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field(ocumentDate; Rec."Document Date")
                {
                    ApplicationArea = All;
                    Caption = 'Document Date';
                    ToolTip = 'Specifies the date when the purchase document was created.';
                }
                field(recordCount; RecCnt_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'Record Count';
                    Editable = false;
                    ToolTip = 'Specifies the value of the Record Count field.';
                }
                field(vendorShipmentNo; Rec."Vendor Shipment No.")
                {
                    ApplicationArea = All;
                    Caption = 'Vendor Shipment No.';
                    ToolTip = 'Specifies the vendor''s shipment number. It is inserted in the corresponding field on the source document during posting.';
                }
                field(orderNo; Rec."Order No.")
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                    ToolTip = 'Specifies the line number of the order that created the entry.';
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
        Rec.SetCurrentKey("Posting Date");
        Rec.Ascending(false);

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Buy-from Vendor No.") = '' THEN
            ERROR('Apply Vendor filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        RecCnt_gInt: Integer;

}
