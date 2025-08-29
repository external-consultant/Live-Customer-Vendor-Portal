page 81261 "API_Overdue Delivery"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiOverdueDelivery';
    DelayedInsert = true;
    EntityName = 'apiOverdueDelivery';
    EntityCaption = 'apiOverdueDelivery';
    EntitySetName = 'apiOverdueDeliverys';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiOverdueDeliverys';
    PageType = API;
    SourceTable = "Purchase Line";

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(documentNo; Rec."Document No.")
                {
                    ApplicationArea = All;
                    Caption = 'Document No.';
                    ToolTip = 'Specifies the document number.';
                }
                field(type; Rec.Type)
                {
                    ApplicationArea = All;
                    Caption = 'Type';
                    ToolTip = 'Specifies the line type.';
                }
                field(buyFromVendorNo; Rec."Buy-from Vendor No.")
                {
                    ApplicationArea = All;
                    Caption = 'Buy-from Vendor No.';
                    ToolTip = 'Specifies the name of the vendor who delivered the items.';
                }
                field(no; Rec."No.")
                {
                    ApplicationArea = All;
                    Caption = 'No.';
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                }
                field(orderNogCod; OrderNo_gCod)
                {
                    ApplicationArea = All;
                    Caption = 'Order No.';
                    ToolTip = 'Specifies the value of the Order No. field.';
                }
                field(description; Rec.Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                    ToolTip = 'Specifies a description of the blanket purchase order.';
                }
                field(description2; Rec."Description 2")
                {
                    ApplicationArea = All;
                    Caption = 'Description 2';
                    ToolTip = 'Specifies information in addition to the description.';
                }
                field(quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    Caption = 'Quantity';
                    ToolTip = 'Specifies the quantity of the purchase order line.';
                }
                field(qtyRcdNotInvoiced; Rec."Qty. Rcd. Not Invoiced")
                {
                    ApplicationArea = All;
                    Caption = 'Qty. Rcd. Not Invoiced';
                    ToolTip = 'Specifies the value of the Qty. Rcd. Not Invoiced field.';
                }
                field(quantityReceived; Rec."Quantity Received")
                {
                    ApplicationArea = All;
                    Caption = 'Quantity Received';
                    ToolTip = 'Specifies how many units of the item on the line have been posted as received.';
                }
                field(outstandingQuantity; Rec."Outstanding Quantity")
                {
                    ApplicationArea = All;
                    Caption = 'Outstanding Quantity';
                    ToolTip = 'Specifies how many units on the order line have not yet been received.';
                }
                field(expectedReceiptDate; Rec."Expected Receipt Date")
                {
                    ApplicationArea = All;
                    Caption = 'Expected Receipt Date';
                    ToolTip = 'Specifies the date you expect the items to be available in your warehouse.';
                }
                field(overDueDays; OverDueDate_gInt)
                {
                    ApplicationArea = All;
                    Caption = 'OverDue Days';
                    Editable = false;
                    ToolTip = 'Specifies the value of the OverDue Days field.';
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    var
        PurchHdr_lRec: Record "Purchase Header";
    begin
        OrderNo_gCod := '';

        Clear(PurchHdr_lRec);
        if PurchHdr_lRec.Get(Rec."Document Type", Rec."Document No.") then
            OrderNo_gCod := PurchHdr_lRec."Vendor Order No.";

        if Rec."Requested Receipt Date" <> 0D then
            OverDueDate_gInt := Today() - Rec."Requested Receipt Date"
        else
            OverDueDate_gInt := 0;
    end;

    trigger OnOpenPage()
    var
        INTKeyValidationMgt: Codeunit "IKV Mgt";
    begin
        Clear(INTKeyValidationMgt);
        INTKeyValidationMgt.onOpenPageKeyValidation();

        Rec.SetFilter("Requested Receipt Date", '<%1', Today());

        //T39004-NS NG 08092023
        IF Rec.GETFILTER("Buy-from Vendor No.") = '' THEN
            ERROR('Apply Vendor filter Require, (Referesh Browser and Login again)');
        //T39004-NE
    end;

    var
        OrderNo_gCod: Code[35];
        OverDueDate_gInt: Integer;
}