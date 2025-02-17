page 33020254 "Warranty Settlement"
{
    PageType = List;
    SourceTable = Table33020252;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Prowac Dealer Code"; "Prowac Dealer Code")
                {
                }
                field("PCR No."; "PCR No.")
                {
                }
                field(Year; Year)
                {
                }
                field("Credit Amount"; "Credit Amount")
                {
                }
                field("Credit Note No."; "Credit Note No.")
                {
                }
                field("Settled Date"; "Settled Date")
                {
                }
                field("Invoice No."; "Invoice No.")
                {
                }
                field(Settled; Settled)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(; Notes)
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("<Action1000000001>")
            {
                Caption = 'Import Settlement Details';
                Ellipsis = false;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CurrFile: File;
                    CurrStream: InStream;
                    ClientFileName: Text[1024];
                    SelectCSVFile: Label 'Select the Warranty Settlement CSV File.';
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
                        XMLPORT.IMPORT(50010, CurrStream);
                        IF NOT ISSERVICETIER THEN CurrFile.CLOSE;
                    END;
                end;
            }
        }
    }

    trigger OnModifyRecord(): Boolean
    begin
        IF "Invoice No." <> '' THEN
            ERROR(Text000);
    end;

    var
        Text000: Label 'You cannot modify Invoiced Settlement.';
}

