tableextension 81234 PurchaseHeader_Ext_33030299 extends "Purchase Header"
{
    fields
    {
        // Add changes to table fields here

        field(81230; "Order Confirmed"; Boolean)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(81231; "Order Confirmed Date"; Date)
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(81232; "Comformation Remarks"; Text[50])
        {
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(81233; "Shipment Status"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
        field(81234; "Package Tracking No"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(81235; "Shipment Method"; Text[50])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        // Add changes to keys here
    }

    fieldgroups
    {
        // Add changes to field groups here
    }
}