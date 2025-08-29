table 81236 ReportDownloadRequest
{
    Access = Public;
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
        field(30; ReportName; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(40; "Report Document No."; Text[30])
        {
            DataClassification = ToBeClassified;
        }
        field(50; StartDate; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(60; EndDate; Date)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}