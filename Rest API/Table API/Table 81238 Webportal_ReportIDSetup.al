table 81238 Webportal_ReportIDSetup
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Report Name"; Enum "Webportal_ReportID_Setup")
        {
            DataClassification = ToBeClassified;
        }
        field(30; "Report ID"; Integer)
        {
            Caption = 'Object ID to Run';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = Const(Report));
        }
        field(40; "Report Caption"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = Const(Report),
                                                                           "Object ID" = FIELD("Report ID")));
            Caption = 'Object Caption to Run';
            Editable = false;
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(pk; "Report Name")
        {
            Clustered = true;
        }
    }
}