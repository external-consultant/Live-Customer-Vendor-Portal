pageextension 81232 PurchaseOrder_Ext extends "Purchase Order"
{
    layout
    {
        addafter(Prepayment)
        {
            group(OrderDetails)
            {
                field("Order Confirmed"; Rec."Order Confirmed")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Confirmed field.', Comment = '%';
                }
                field("Order Confirmed Date"; Rec."Order Confirmed Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Order Confirmed Date field.', Comment = '%';
                }
                field("Comformation Remarks"; Rec."Comformation Remarks")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Comformation Remarks field.', Comment = '%';
                }
            }
        }
        // Add changes to page layout here
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}