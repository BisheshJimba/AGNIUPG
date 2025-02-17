page 50052 "Dimension Correction"
{
    DelayedInsert = true;
    InsertAllowed = false;
    PageType = Worksheet;
    Permissions = TableData 17 = rm,
                  TableData 21 = rm,
                  TableData 25 = rm,
                  TableData 32 = rm,
                  TableData 110 = rm,
                  TableData 111 = rm,
                  TableData 112 = rm,
                  TableData 113 = rm,
                  TableData 114 = rm,
                  TableData 115 = rm,
                  TableData 120 = rm,
                  TableData 121 = rm,
                  TableData 122 = rm,
                  TableData 123 = rm,
                  TableData 124 = rm,
                  TableData 125 = rm,
                  TableData 271 = rm,
                  TableData 379 = rm,
                  TableData 380 = rm,
                  TableData 5601 = rm,
                  TableData 5802 = rm,
                  TableData 6650 = rm,
                  TableData 6651 = rm,
                  TableData 6660 = rm,
                  TableData 6661 = rm;
    SourceTable = Table14125601;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(DocumentNo; DocumentNo)
                {
                    Caption = 'Document No.';

                    trigger OnValidate()
                    begin
                        UpdateTempTable; //get lines
                    end;
                }
                field("Reason Note"; ReasonText)
                {
                }
            }
            repeater(Lines)
            {
                field("Line No."; "Line No.")
                {
                }
                field("Table ID"; "Table ID")
                {
                }
                field("Table Name"; "Table Name")
                {
                }
                field("Primary Key 1"; "Primary Key 1")
                {
                }
                field("Primary Key 2"; "Primary Key 2")
                {
                }
                field("Primary Key 3"; "Primary Key 3")
                {
                }
                field("Primary Key 4"; "Primary Key 4")
                {
                }
                field("Document No."; "Document No.")
                {
                }
                field("Dimension Set ID"; "Dimension Set ID")
                {
                    Style = StandardAccent;
                    StyleExpr = TRUE;
                }
                field("New Dimension Set ID"; "New Dimension Set ID")
                {
                    Caption = 'New Dimension Set ID';
                    Style = StrongAccent;
                    StyleExpr = TRUE;
                }
                field("Dimension 1"; "Dimension 1")
                {
                    CaptionClass = '1,2,1';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(1, "Dimension 1");
                    end;
                }
                field("Dimension 2"; "Dimension 2")
                {
                    CaptionClass = '1,2,2';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(2, "Dimension 2");
                    end;
                }
                field("Dimension 3"; "Dimension 3")
                {
                    CaptionClass = '1,2,3';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(3, "Dimension 3");
                    end;
                }
                field("Dimension 4"; "Dimension 4")
                {
                    CaptionClass = '1,2,4';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(4, "Dimension 4");
                    end;
                }
                field("Dimension 5"; "Dimension 5")
                {
                    CaptionClass = '1,2,5';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(5, "Dimension 5");
                    end;
                }
                field("Dimension 6"; "Dimension 6")
                {
                    CaptionClass = '1,2,6';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(6, "Dimension 6");
                    end;
                }
                field("Dimension 7"; "Dimension 7")
                {
                    CaptionClass = '1,2,7';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(7, "Dimension 7");
                    end;
                }
                field("Dimension 8"; "Dimension 8")
                {
                    CaptionClass = '1,2,8';

                    trigger OnValidate()
                    begin
                        ValidateShortcutDimCode(8, "Dimension 8");
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group()
            {
                action(UpdateEntries)
                {
                    Caption = 'Update entries';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        UpdateLedgerTables;
                    end;
                }
                action("Open Selected Document")
                {
                }
            }
        }
    }

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        TempTable.DELETEALL;
    end;

    var
        DimSetupTable: Record "14125600";
        SelectTable: Integer;
        DimSetupPage: Page "50050";
        DocumentNo: Code[20];
        ReasonText: Text;
        TempTable: Record "14125601";
        ShortcutDimCode: array[8] of Code[20];
        LineType: Option "Selected Line","All Lines";
        DimValue: Record "349";
        DimSetEntry: Record "480";
        GenLedgerSetup: Record "98";
        TempStr: Text;
        DimMgt: Codeunit "408";
        NewDimensionSetId: Integer;
        DimText: array[8] of Text;
        RecRef: RecordRef;
        MyFieldRef: FieldRef;
        EntryNo: Integer;
        DimLogTable: Record "14125602";
        MyFieldRef1: FieldRef;
        MyFieldRef2: FieldRef;
        MyFieldRef3: FieldRef;
        MyFieldRef4: FieldRef;
        MyFieldRef5: FieldRef;
        MyFieldRef6: FieldRef;
        MyFieldRef7: FieldRef;
        MyFieldRef8: FieldRef;
        IsUpdated: Boolean;

    local procedure UpdateTempTable()
    var
        DimCorrSetup: Record "14125600";
        DimFieldNo: Integer;
        TempTable: Record "14125601";
        EntryNo: Integer;
    begin
        IF DocumentNo = '' THEN BEGIN
            TempTable.DELETEALL;
            CLEARALL;
            EXIT;
        END;

        TempTable.DELETEALL;

        DimCorrSetup.RESET;
        DimCorrSetup.SETRANGE(Skip, FALSE);
        //DimCorrSetup.SETRANGE("Table ID", SelectTable);
        IF DimCorrSetup.FINDFIRST THEN
            REPEAT
                CLEAR(RecRef);
                CLEAR(MyFieldRef);
                RecRef.OPEN(DimCorrSetup."Table ID");
                MyFieldRef := RecRef.FIELD(DimCorrSetup."Document No. Field No.");
                MyFieldRef.SETRANGE(DocumentNo);
                IF RecRef.FINDFIRST THEN
                    REPEAT
                        EntryNo := 0;
                        TempTable.RESET;
                        IF TempTable.FINDLAST THEN
                            EntryNo := TempTable."Line No.";
                        TempTable.INIT;
                        TempTable."Line No." := EntryNo + 1;
                        TempTable."Table ID" := DimCorrSetup."Table ID";
                        TempTable."Table Name" := FORMAT(RecRef.CAPTION);
                        //primary key
                        IF DimCorrSetup."Primary Key 1" = 0 THEN
                            ERROR('Table %1, requires at least 1 primary key setup.', DimCorrSetup."Table Caption");
                        TempTable."Primary Key 1" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 1"));
                        IF DimCorrSetup."Primary Key 2" <> 0 THEN
                            TempTable."Primary Key 2" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 2"));
                        IF DimCorrSetup."Primary Key 3" <> 0 THEN
                            TempTable."Primary Key 3" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 3"));
                        IF DimCorrSetup."Primary Key 4" <> 0 THEN
                            TempTable."Primary Key 4" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 4"));

                        TempTable."Document No." := FORMAT(RecRef.FIELD(DimCorrSetup."Document No. Field No."));
                        TempStr := FORMAT(RecRef.FIELD(DimCorrSetup."Dimension Set Id - Field No."));
                        IF DimCorrSetup."Dimension Set Id - Field No." <> 0 THEN
                            EVALUATE(TempTable."Dimension Set ID", TempStr);
                        TempTable."New Dimension Set ID" := TempTable."Dimension Set ID";


                        /*IF DimCorrSetup."Dimension 1 - Field No." <> 0 THEN
                          TempTable."Dimension 1" := FORMAT(RecRef.FIELD(DimCorrSetup."Dimension 1 - Field No."));
                        IF DimCorrSetup."Dimension 2 - Field No." <> 0 THEN
                         TempTable."Dimension 2" := FORMAT(RecRef.FIELD(DimCorrSetup."Dimension 2 - Field No."));
                         */
                        IF DimCorrSetup."Dimension Set Id - Field No." <> 0 THEN BEGIN
                            GenLedgerSetup.GET;
                            DimSetEntry.RESET;
                            DimSetEntry.SETFILTER("Dimension Set ID", FORMAT(RecRef.FIELD(DimCorrSetup."Dimension Set Id - Field No.")));
                            IF DimSetEntry.FINDFIRST THEN
                                REPEAT
                                    CASE DimSetEntry."Dimension Code" OF
                                        GenLedgerSetup."Shortcut Dimension 1 Code":
                                            TempTable."Dimension 1" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 2 Code":
                                            TempTable."Dimension 2" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 3 Code":
                                            TempTable."Dimension 3" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 4 Code":
                                            TempTable."Dimension 4" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 5 Code":
                                            TempTable."Dimension 5" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 6 Code":
                                            TempTable."Dimension 6" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 7 Code":
                                            TempTable."Dimension 7" := DimSetEntry."Dimension Value Code";
                                        GenLedgerSetup."Shortcut Dimension 8 Code":
                                            TempTable."Dimension 8" := DimSetEntry."Dimension Value Code";
                                    END;

                                UNTIL DimSetEntry.NEXT = 0;
                        END ELSE BEGIN
                            TempTable."Dimension 1" := FORMAT(RecRef.FIELD(21));  //Sameer
                            TempTable."Dimension 2" := FORMAT(RecRef.FIELD(22));  //Sameer
                        END;

                        TempTable.INSERT;

                    UNTIL RecRef.NEXT = 0;
            //MESSAGE(FORMAT(recref.FIELD(DimFieldNo)));



            UNTIL DimCorrSetup.NEXT = 0;

        CurrPage.UPDATE;


        /*IF DocumentNo = '' THEN BEGIN
          TempTable.DELETEALL;
          CLEARALL;
          EXIT;
          END;
        
        TempTable.DELETEALL;
        
        DimCorrSetup.RESET;
        DimCorrSetup.SETRANGE(Skip, FALSE);
        //DimCorrSetup.SETRANGE("Table ID", SelectTable);
        IF DimCorrSetup.FINDFIRST THEN
          REPEAT
            CLEAR(RecRef);
            CLEAR(MyFieldRef);
            RecRef.OPEN(DimCorrSetup."Table ID");
            MyFieldRef := RecRef.FIELD(DimCorrSetup."Document No. Field No.");
            MyFieldRef.SETRANGE(DocumentNo);
            IF RecRef.FINDFIRST THEN
              REPEAT
                EntryNo := 0;
                TempTable.RESET;
                IF TempTable.FINDLAST THEN
                  EntryNo := TempTable."Line No.";
                TempTable.INIT;
                TempTable."Line No." := EntryNo +1 ;
                TempTable."Table ID" := DimCorrSetup."Table ID";
                TempTable."Table Name" := FORMAT(RecRef.CAPTION);
                //primary key
                IF DimCorrSetup."Primary Key 1" = 0 THEN
                  ERROR('Table %1, requires at least 1 primary key setup.', DimCorrSetup."Table Caption");
                TempTable."Primary Key 1" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 1"));
                IF DimCorrSetup."Primary Key 2" <> 0 THEN
                  TempTable."Primary Key 2" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 2"));
                IF DimCorrSetup."Primary Key 3" <> 0 THEN
                  TempTable."Primary Key 3" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 3"));
                IF DimCorrSetup."Primary Key 4" <> 0 THEN
                  TempTable."Primary Key 4" := FORMAT(RecRef.FIELD(DimCorrSetup."Primary Key 4"));
        
                TempTable."Document No." := FORMAT(RecRef.FIELD(DimCorrSetup."Document No. Field No."));
                TempStr := FORMAT(RecRef.FIELD(DimCorrSetup."Dimension Set Id - Field No."));
                IF DimCorrSetup."Dimension Set Id - Field No." <> 0 THEN
                  EVALUATE(TempTable."Dimension Set ID",TempStr );
                TempTable."New Dimension Set ID" := TempTable."Dimension Set ID";
        
        
                {IF DimCorrSetup."Dimension 1 - Field No." <> 0 THEN
                  TempTable."Dimension 1" := FORMAT(RecRef.FIELD(DimCorrSetup."Dimension 1 - Field No."));
                IF DimCorrSetup."Dimension 2 - Field No." <> 0 THEN
                 TempTable."Dimension 2" := FORMAT(RecRef.FIELD(DimCorrSetup."Dimension 2 - Field No."));
                 }
                IF DimCorrSetup."Dimension Set Id - Field No." <> 0 THEN BEGIN
                  GenLedgerSetup.GET;
                  DimSetEntry.RESET;
                  DimSetEntry.SETFILTER("Dimension Set ID", FORMAT(RecRef.FIELD(DimCorrSetup."Dimension Set Id - Field No.")));
                  IF DimSetEntry.FINDFIRST THEN
                    REPEAT
                      CASE DimSetEntry."Dimension Code" OF
                        GenLedgerSetup."Shortcut Dimension 1 Code":
                          TempTable."Dimension 1" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 2 Code":
                          TempTable."Dimension 2" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 3 Code":
                          TempTable."Dimension 3" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 4 Code":
                          TempTable."Dimension 4" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 5 Code":
                          TempTable."Dimension 5" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 6 Code":
                          TempTable."Dimension 6" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 7 Code":
                          TempTable."Dimension 7" := DimSetEntry."Dimension Value Code";
                        GenLedgerSetup."Shortcut Dimension 8 Code":
                          TempTable."Dimension 8" := DimSetEntry."Dimension Value Code";
                        END;
        
                    UNTIL DimSetEntry.NEXT =0;
                  END;
        
        
        
                TempTable.INSERT;
        
              UNTIL RecRef.NEXT = 0;
            //MESSAGE(FORMAT(recref.FIELD(DimFieldNo)));
        
        
        
          UNTIL DimCorrSetup.NEXT =0;
        
        CurrPage.UPDATE;*/

    end;

    local procedure UpdateLedgerTables()
    var
        OldDimSetID: Integer;
    begin
        //IF ReasonText = '' THEN
        //  ERROR('Please insert reason note.');

        IF NOT DIALOG.CONFIRM('Are you sure you want to update?', FALSE) THEN
            ERROR('Update cancelled.');
        TempTable.RESET;
        TempTable.COPYFILTERS(Rec);
        IF TempTable.COUNT = 0 THEN BEGIN
            MESSAGE('There is nothing to update.');
            EXIT;
        END;

        // Update Ledger tables
        IF TempTable.FINDFIRST THEN
            REPEAT
                DimSetupTable.RESET;
                DimSetupTable.SETRANGE(Skip, FALSE);
                DimSetupTable.SETRANGE("Table ID", TempTable."Table ID");
                IF DimSetupTable.FINDFIRST THEN
                    REPEAT

                        CLEAR(RecRef);
                        CLEAR(MyFieldRef);

                        RecRef.OPEN(DimSetupTable."Table ID"); //open ledger table

                        MyFieldRef := RecRef.FIELD(DimSetupTable."Document No. Field No."); //get document no.
                        MyFieldRef.SETFILTER(TempTable."Document No.");     //filter document no.

                        IF TempTable."Primary Key 1" = '' THEN
                            ERROR('Table ID %1, requires at least one primary key in setup.', DimSetupTable."Table ID");

                        MyFieldRef := RecRef.FIELD(DimSetupTable."Primary Key 1");
                        MyFieldRef.SETFILTER(TempTable."Primary Key 1"); //filter primary key 1

                        IF TempTable."Primary Key 2" <> '' THEN BEGIN
                            MyFieldRef := RecRef.FIELD(DimSetupTable."Primary Key 2");
                            MyFieldRef.SETFILTER(TempTable."Primary Key 2");
                        END;

                        IF TempTable."Primary Key 3" <> '' THEN BEGIN
                            MyFieldRef := RecRef.FIELD(DimSetupTable."Primary Key 3");
                            MyFieldRef.SETFILTER(TempTable."Primary Key 3");
                        END;

                        IF TempTable."Primary Key 4" <> '' THEN BEGIN
                            MyFieldRef := RecRef.FIELD(DimSetupTable."Primary Key 4");
                            MyFieldRef.SETFILTER(TempTable."Primary Key 4");
                        END;


                        //modify ledger table - dimension set id and fields
                        IF RecRef.FINDFIRST THEN BEGIN
                            IF DimSetupTable."Dimension 1 - Field No." <> 0 THEN BEGIN
                                MyFieldRef1 := RecRef.FIELD(DimSetupTable."Dimension 1 - Field No.");
                                MyFieldRef1.VALUE := TempTable."Dimension 1";
                            END;
                            IF DimSetupTable."Dimension 2 - Field No." <> 0 THEN BEGIN
                                MyFieldRef2 := RecRef.FIELD(DimSetupTable."Dimension 2 - Field No.");
                                MyFieldRef2.VALUE := TempTable."Dimension 2";
                            END;
                            IF DimSetupTable."Dimension 3 - Field No." <> 0 THEN BEGIN
                                MyFieldRef3 := RecRef.FIELD(DimSetupTable."Dimension 3 - Field No.");
                                MyFieldRef3.VALUE := TempTable."Dimension 3";
                            END;
                            IF DimSetupTable."Dimension 4 - Field No." <> 0 THEN BEGIN
                                MyFieldRef4 := RecRef.FIELD(DimSetupTable."Dimension 4 - Field No.");
                                MyFieldRef4.VALUE := TempTable."Dimension 4";
                            END;
                            IF DimSetupTable."Dimension 5 - Field No." <> 0 THEN BEGIN
                                MyFieldRef5 := RecRef.FIELD(DimSetupTable."Dimension 5 - Field No.");
                                MyFieldRef5.VALUE := TempTable."Dimension 5";
                            END;
                            IF DimSetupTable."Dimension 6 - Field No." <> 0 THEN BEGIN
                                MyFieldRef6 := RecRef.FIELD(DimSetupTable."Dimension 6 - Field No.");
                                MyFieldRef6.VALUE := TempTable."Dimension 6";
                            END;
                            IF DimSetupTable."Dimension 7 - Field No." <> 0 THEN BEGIN
                                MyFieldRef7 := RecRef.FIELD(DimSetupTable."Dimension 7 - Field No.");
                                MyFieldRef7.VALUE := TempTable."Dimension 7";
                            END;
                            IF DimSetupTable."Dimension 8 - Field No." <> 0 THEN BEGIN
                                MyFieldRef8 := RecRef.FIELD(DimSetupTable."Dimension 8 - Field No.");
                                MyFieldRef8.VALUE := TempTable."Dimension 8";
                            END;
                            IF DimSetupTable."Dimension Set Id - Field No." <> 0 THEN BEGIN
                                MyFieldRef := RecRef.FIELD(DimSetupTable."Dimension Set Id - Field No."); //dimension set id
                                MyFieldRef.VALUE := TempTable."New Dimension Set ID";
                            END;
                            RecRef.MODIFY;

                            //insert into log table
                            EntryNo := 0;
                            DimLogTable.RESET;
                            IF DimLogTable.FINDLAST THEN
                                EntryNo := DimLogTable."Entry No.";
                            DimLogTable.RESET;
                            DimLogTable.INIT;
                            DimLogTable.TRANSFERFIELDS(TempTable);
                            DimLogTable."Entry No." := EntryNo + 1;
                            DimLogTable."Reason Text" := ReasonText;
                            DimLogTable."User ID" := USERID;
                            DimLogTable.Date := TODAY;
                            DimLogTable.INSERT;
                            IsUpdated := TRUE;
                        END;

                    UNTIL DimSetupTable.NEXT = 0;


            UNTIL TempTable.NEXT = 0;

        IF IsUpdated THEN
            MESSAGE('Dimension updated.');
    end;

    [Scope('Internal')]
    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        /*IF NOT FINDFIRST THEN
          ERROR('No any lines.');*/
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "New Dimension Set ID");
        //UpdateDimensionLine;
        CurrPage.UPDATE;


        //update new dimension set id to all temp lines
        /*TempTable.RESET;
        TempTable.COPYFILTERS(Rec);
        IF TempTable.FINDFIRST THEN
          REPEAT
            TempTable."New Dimension Set ID" := NewDimensionSetId;
            TempTable.MODIFY;
          UNTIL TempTable.NEXT = 0;
        
        CurrPage.UPDATE(FALSE);
        */

    end;
}

