page 33020333 "Application List"
{
    CardPageID = "Application Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Table33020330;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Name; Name)
                {
                }
                field("Phone No."; "Phone No.")
                {
                }
                field("Mobile No."; "Mobile No.")
                {
                }
                field(Email; Email)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000001>")
            {
                Caption = 'Import File';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CurrFile: File;
                    CurrStream: InStream;
                    ClientFileName: Text[1024];
                    SelectCSVFile: Label 'Select the CSV Requisition File.';
                begin
                    BEGIN
                        IF ISSERVICETIER THEN BEGIN
                            IF NOT UPLOADINTOSTREAM(
                                              SelectCSVFile,
                                               'C:\',
                                               'XML File *.csv| *.csv',
                                                ClientFileName,
                                                CurrStream) THEN
                                EXIT;
                        END
                        ELSE BEGIN
                            CurrFile.OPEN('C:\');
                            CurrFile.CREATEINSTREAM(CurrStream);
                        END;
                        XMLPORT.IMPORT(50012, CurrStream);
                        IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                    END;
                end;
            }
        }
    }

    [Scope('Internal')]
    procedure GetSelectionFilter(): Code[250]
    var
        Application: Record "33020330";
        RecCount: Integer;
        More: Boolean;
        SelectionFilter: Code[80];
        FirstVal: Code[20];
        LastVal: Code[20];
    begin
        CurrPage.SETSELECTIONFILTER(Application);
        Application.SETCURRENTKEY("No.");
        RecCount := Application.COUNT;
        IF RecCount > 0 THEN BEGIN
            Application.FIND('-');
            WHILE RecCount > 0 DO BEGIN
                RecCount := RecCount - 1;
                Application.MARKEDONLY(FALSE);
                FirstVal := Application."No.";
                LastVal := Application."No.";
                More := (RecCount > 0);
                WHILE More DO
                    IF Application.NEXT = 0 THEN
                        More := FALSE
                    ELSE
                        IF NOT Application.MARK THEN
                            More := FALSE
                        ELSE BEGIN
                            LastVal := Application."No.";
                            RecCount := RecCount - 1;
                            IF RecCount = 0 THEN
                                More := FALSE;
                        END;
                IF SelectionFilter <> '' THEN
                    SelectionFilter := SelectionFilter + '|';
                IF FirstVal = LastVal THEN
                    SelectionFilter := SelectionFilter + FirstVal
                ELSE
                    SelectionFilter := SelectionFilter + FirstVal + '..' + LastVal;
                IF RecCount > 0 THEN BEGIN
                    Application.MARKEDONLY(TRUE);
                    Application.NEXT;
                END;
            END;
        END;
        EXIT(SelectionFilter);
    end;
}

