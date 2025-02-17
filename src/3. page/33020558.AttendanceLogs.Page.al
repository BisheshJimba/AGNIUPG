page 33020558 "Attendance Logs"
{
    DeleteAllowed = false;
    PageType = List;
    SourceTable = Table33020550;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Employee ID"; "Employee ID")
                {
                }
                field(Date; Date)
                {
                }
                field(Time; Time)
                {
                }
                field(MachineCode; MachineCode)
                {
                }
                field("Shortcut Dimension 1 Code"; "Shortcut Dimension 1 Code")
                {
                }
                field("Shortcut Dimension 2 Code"; "Shortcut Dimension 2 Code")
                {
                }
                field("Machine Center"; "Machine Center")
                {
                }
                field("Assigned User ID"; "Assigned User ID")
                {
                }
                field("Creation Date"; "Creation Date")
                {
                }
            }
        }
    }

    actions
    {
        area(creation)
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
                        XMLPORT.IMPORT(50015, CurrStream);
                        IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                    END;
                end;
            }
        }
    }
}

