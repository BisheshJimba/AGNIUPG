pageextension 50425 pageextension50425 extends "Posted Approval Entries"
{
    // 22.10.2015 EB.P7 #NAV2016 merge
    //   Setfilters function added

    procedure Setfilters(TableId: Integer; DocumentNo: Code[20])
    begin
        IF TableId <> 0 THEN BEGIN
            Rec.FILTERGROUP(2);
            Rec.SETRANGE("Table ID", TableId);
            IF DocumentNo <> '' THEN
                Rec.SETRANGE("Document No.", DocumentNo);
            Rec.FILTERGROUP(0);
        END;
    end;
}

