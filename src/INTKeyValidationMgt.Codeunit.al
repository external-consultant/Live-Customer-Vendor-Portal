codeunit 81230 "IKV Mgt"
{

    trigger OnRun()
    begin
    end;

    procedure onOpenPageKeyValidation()
    var
        INTWebPortalSetup: Record "INT Web Portal - Setup";
        INTWebPortalSetupPage: Page "INT Web Portal Setup";
        MyNotification: Notification;
        EndDate: Date;
        NoofDay: Integer;
        ExpireLbl: Label 'Complain App will expire in %1 days,Contact to Intech Systems Pvt. Ltd. for activation', Comment = '%1=days';
        TextLbl: Label 'Complaint Setup not Created yet,\Do you want to Create it Now?';
    begin
        // if not INTWebPortalSetup.Get() then
        //     if Confirm(TextLbl, true) then begin
        //         INTWebPortalSetupPage.RunModal();
        //         INTWebPortalSetup.Get();
        //         INTWebPortalSetup.TestField("Activation Key");
        //     end;

        // EndDate := ValidateEndDateFunction(INTWebPortalSetup."Activation Key");
        // if EndDate < Today() then
        //     Error('Complain App was expired on %1,Contact to Intech Systems Pvt. Ltd. for activation', EndDate);

        // NoofDay := EndDate - Today();
        // if NoofDay < 15 then begin
        //     MyNotification.Message(StrSubstNo(ExpireLbl, NoofDay));
        //     MyNotification.AddAction('Activate Now', Codeunit::"IKV Mgt", 'ExpireNotification');
        //     MyNotification.Send();
        // end;
    end;

    procedure ExpireNotification(MyNotification: Notification)
    var
        WebPortalSetupPage: Page "INT Web Portal Setup";
    begin
        WebPortalSetupPage.RunModal();
    end;

    procedure GetKey(NoofDays: Integer): Code[250]
    var
        BuildKey: Text;
    begin
        BuildKey := GetTSValue(Today()) + 'P' + GetTSValue(Today() + NoofDays);

        BuildKey := CopyStr(GetRandomString(), 1, 5) + BuildKey + CopyStr(GetRandomString(), 1, 6);

        exit(CopyStr(BuildKey, 1, 250));
    end;

    procedure ValidateEndDateFunction(BuildKey: Code[250]): Date
    var
        EnDate: Date;
        FirstDate: Date;
    begin
        if BuildKey = '' then
            Error('Invalid Key');

        GetDTValue(BuildKey, FirstDate, EnDate);

        exit(EnDate);
    end;

    procedure ValidateKey(BuildKey: Code[250]): Date
    var
        EnDate: Date;
        FirstDate: Date;
    begin
        if BuildKey = '' then
            Error('Invalid Key');

        GetDTValue(BuildKey, FirstDate, EnDate);

        if FirstDate <> Today() then
            Error('Invalid Key');

        exit(EnDate);
    end;

    local procedure GetRandomString(): Text
    begin
        exit(DelChr(Format(CreateGuid()), '=', '{}-'));
    end;


    local procedure GetIntValue(InputKey: Code[2]): Integer
    begin
        case InputKey of
            'VX':
                exit(0);
            'GR':
                exit(1);
            'CD':
                exit(2);
            'WE':
                exit(3);
            'HI':
                exit(4);
            'LC':
                exit(5);
            'QS':
                exit(6);
            'BU':
                exit(7);
            'WX':
                exit(8);
            'HY':
                exit(9);
        end;
    end;

    local procedure GetStrValue(InputKey: Text[1]): Text[2]
    begin
        case InputKey of
            '0':
                exit('VX');
            '1':
                exit('GR');
            '2':
                exit('CD');
            '3':
                exit('WE');
            '4':
                exit('HI');
            '5':
                exit('LC');
            '6':
                exit('QS');
            '7':
                exit('BU');
            '8':
                exit('WX');
            '9':
                exit('HY');
        end;
    end;

    local procedure GetTSValue(Date: Date): Text[50]
    var
        DDInt: Integer;
        i: Integer;
        MMInt: Integer;
        YYYYInt: Integer;
        DDLocal: Text[2];
        MMLocal: Text[2];
        YYYYLocal: Text[4];
        FullDate: Text[100];
        EncrptValueDate: Text[250];
    begin
        DDInt := Date2DMY(Date, 1);
        MMInt := Date2DMY(Date, 2);
        YYYYInt := Date2DMY(Date, 3);

        DDLocal := CopyStr(Format(DDInt), 1, MaxStrLen(DDLocal));
        if StrLen(DDLocal) = 1 then
            DDLocal := CopyStr('0' + DDLocal, 1, MaxStrLen(DDLocal));

        MMLocal := CopyStr(Format(MMInt), 1, MaxStrLen(MMLocal));
        if StrLen(MMLocal) = 1 then
            MMLocal := CopyStr('0' + MMLocal, 1, MaxStrLen(MMLocal));

        YYYYLocal := CopyStr(Format(YYYYInt), 1, MaxStrLen(YYYYLocal));
        if StrLen(YYYYLocal) = 2 then
            YYYYLocal := CopyStr('20' + YYYYLocal, 1, MaxStrLen(YYYYLocal));

        FullDate := DDLocal + MMLocal + YYYYLocal;

        EncrptValueDate := '';
        for i := 1 to StrLen(FullDate) do
            // IF EncrptValueDate = '' THEN
            //     EncrptValueDate := GetStrValue(copystr(FORMAT(FullDate[i]), 1, MaxStrLen(EncrptValueDate)))
            // ELSE
            //     EncrptValueDate += GetStrValue(copystr(FORMAT(FullDate[i]), 1, MaxStrLen(EncrptValueDate)));
            if EncrptValueDate = '' then
                EncrptValueDate := GetStrValue(CopyStr(Format(FullDate[i]), 1, 1))
            else
                EncrptValueDate += GetStrValue(CopyStr(Format(FullDate[i]), 1, 1));

        exit(CopyStr(EncrptValueDate, 1, 50));
    end;

    local procedure GetDTValue(KeyValue: Code[1024]; var FirstDate: Date; var EnDate: Date): Date
    var
        FirstPart: Code[500];
        SecondPart: Code[500];
    begin
        if KeyValue = '' then
            Error('Please enter valid Key Value');

        if StrPos(KeyValue, 'P') = 0 then
            Error('Please enter valid Key Value');

        if StrLen(KeyValue) < 44 then
            Error('Please enter valid Key Value');

        KeyValue := CopyStr(KeyValue, 6, 33);

        FirstPart := CopyStr(CopyStr(KeyValue, 1, StrPos(KeyValue, 'P') - 1), 1, MaxStrLen(FirstPart));
        SecondPart := CopyStr(CopyStr(KeyValue, StrPos(KeyValue, 'P') + 1), 1, MaxStrLen(SecondPart));

        FirstDate := CalDatePart(FirstPart);
        EnDate := CalDatePart(SecondPart);
    end;

    local procedure CalDatePart(KeyValue: Code[500]): Date
    var
        FindValue: Code[2];
        LastFinalValue: Code[500];
        DDInt: Integer;
        i: Integer;
        MMInt: Integer;
        YYYYInt: Integer;
        DDLocal: Text[2];
        MMLocal: Text[2];
        YYYYLocal: Text[4];
    begin
        if KeyValue = '' then
            exit;

        LastFinalValue := '';

        for i := 1 to StrLen(KeyValue) do begin
            FindValue := CopyStr(Format(KeyValue[i]), 1, MaxStrLen(FindValue));
            i += 1;
            FindValue += Format(KeyValue[i]);

            if LastFinalValue = '' then
                LastFinalValue := CopyStr(Format(GetIntValue(FindValue)), 1, MaxStrLen(LastFinalValue))
            else
                LastFinalValue += Format(GetIntValue(FindValue));
        end;

        if StrLen(LastFinalValue) <> 8 then
            Error('Please enter valid Key Value');

        DDLocal := CopyStr(LastFinalValue, 1, 2);
        MMLocal := CopyStr(LastFinalValue, 3, 2);
        YYYYLocal := CopyStr(LastFinalValue, 5, 4);

        if not Evaluate(DDInt, DDLocal) then
            Error('Please enter valid Key Value');

        if not Evaluate(MMInt, MMLocal) then
            Error('Please enter valid Key Value');

        if not Evaluate(YYYYInt, YYYYLocal) then
            Error('Please enter valid Key Value');

        exit(DMY2Date(DDInt, MMInt, YYYYInt));
    end;
}

