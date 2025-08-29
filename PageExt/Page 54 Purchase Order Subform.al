pageextension 81233 MyExtension extends "Purchase Order Subform"
{
    layout
    {
        addafter("Qty. to Receive")
        {
            field("Vendor Ship Qty."; Rec."Vendor Ship Qty.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Vendor Ship Qty. field.';
                Editable = false;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}