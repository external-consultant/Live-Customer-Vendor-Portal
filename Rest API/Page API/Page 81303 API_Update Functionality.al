page 81303 "API_Update Functionality"
{
    // version WebPortal
    APIGroup = 'API';
    APIPublisher = 'ISPL';
    APIVersion = 'v2.0';
    Caption = 'apiUpdatefunctionality';
    DelayedInsert = true;
    EntityName = 'apiUpdatefunctionality';
    EntityCaption = 'apiUpdatefunctionality';
    EntitySetName = 'apiUpdatefunctionalitys';    //Make Sure First Char in Small Letter and don't use any special char or space
    EntitySetCaption = 'apiUpdatefunctionalitys';
    PageType = API;
    SourceTable = Webportal_UpdateFun;
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {

                field(poNo; Rec."PO No.")
                {
                    Caption = 'PO No.';
                }
                field(poLineNo; Rec."PO Line No.")
                {
                    Caption = 'PO Line No.';
                }
                field(quantityToSend; Rec."Quantity to Send")
                {
                    Caption = 'Quantity to Send';
                }
                field(shipmentNo; Rec."Shipment No.")
                {
                    Caption = 'Shipment No.';
                }
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        GenralLedgSetup_lRec: Record "General Ledger Setup";
        BankACCLedEntry_lRec: Record "Bank Account Ledger Entry";
    begin
        Rec.TestField("PO No.");
        Rec.TestField("PO Line No.");
        Rec.TestField("Quantity to Send");
        Rec.TestField("Shipment No.");

        Message('Added Successfully');
    end;

}
