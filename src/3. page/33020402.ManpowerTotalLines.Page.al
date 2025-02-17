page 33020402 "Manpower Total Lines"
{
    Editable = false;
    PageType = ListPart;
    SourceTable = Table33020377;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Department Code"; "Department Code")
                {
                }
                field("Department Name"; "Department Name")
                {
                    Editable = false;
                }
                field("Position 1"; "Position 1")
                {
                    Caption = '<Position 1>';

                    trigger OnDrillDown()
                    begin
                        /*
                        ///Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,4));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,4);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,4));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,4));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                        */

                    end;
                }
                field("Position 2"; "Position 2")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                       //Inserting budget details in Manpower Budget Entry table and viewing the form.
                       GblMnprBdgtEntry.RESET;
                       GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                       GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                       GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,5));
                       IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                         GblMnprBdgtEntry2.INIT;
                         GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                         GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                         GblMnprBdgtEntry2."Department Code" := "Department Code";
                         GblMnprBdgtEntry2."Department Name" := "Department Name";
                         GblMnprBdgtEntry2.Date := TODAY;
                         GblMnprBdgtEntry2.Position := getPostingCode(33020377,5);
                         GblMnprBdgtEntry2.INSERT;
                         COMMIT;
                         //Setting filter on view.
                         GblMnprBdgtEntry3.RESET;
                         GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                         GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                         GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,5));
                         GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                         GblMnprBdgtEntryList.RUNMODAL;
                       END ELSE BEGIN
                         //Setting filter on view.
                         GblMnprBdgtEntry3.RESET;
                         GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                         GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                         GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,5));
                         GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                         GblMnprBdgtEntryList.RUNMODAL;
                       END;
                       */

                    end;
                }
                field("Position 3"; "Position 3")
                {

                    trigger OnDrillDown()
                    begin

                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,6));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,6);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,6));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,6));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                        */

                    end;
                }
                field("Position 4"; "Position 4")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,7));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,7);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,7));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,7));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                        */

                    end;
                }
                field("Position 5"; "Position 5")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,8));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,8);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,8));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,8));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                         */

                    end;
                }
                field("Position 6"; "Position 6")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,9));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,9);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,9));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,9));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                          */

                    end;
                }
                field("Position 7"; "Position 7")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,10));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,10);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,10));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,10));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                         */

                    end;
                }
                field("Position 8"; "Position 8")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,11));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,11);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,11));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,11));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                          */

                    end;
                }
                field("Position 9"; "Position 9")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,12));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,12);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,12));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,12));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                         */

                    end;
                }
                field("Position 10"; "Position 10")
                {

                    trigger OnDrillDown()
                    begin
                        /*
                        //Inserting budget details in Manpower Budget Entry table and viewing the form.
                        GblMnprBdgtEntry.RESET;
                        GblMnprBdgtEntry.SETRANGE("Fiscal Year","Fiscal Year");
                        GblMnprBdgtEntry.SETRANGE("Department Code","Department Code");
                        GblMnprBdgtEntry.SETRANGE(Position,getPostingCode(33020377,13));
                        IF NOT GblMnprBdgtEntry.FIND('-') THEN BEGIN
                          GblMnprBdgtEntry2.INIT;
                          GblMnprBdgtEntry2."Entry No." := getLastEntryNo + 1;
                          GblMnprBdgtEntry2."Fiscal Year" := "Fiscal Year";
                          GblMnprBdgtEntry2."Department Code" := "Department Code";
                          GblMnprBdgtEntry2."Department Name" := "Department Name";
                          GblMnprBdgtEntry2.Date := TODAY;
                          GblMnprBdgtEntry2.Position := getPostingCode(33020377,13);
                          GblMnprBdgtEntry2.INSERT;
                          COMMIT;
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,13));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END ELSE BEGIN
                          //Setting filter on view.
                          GblMnprBdgtEntry3.RESET;
                          GblMnprBdgtEntry3.SETRANGE("Fiscal Year","Fiscal Year");
                          GblMnprBdgtEntry3.SETRANGE("Department Code","Department Code");
                          GblMnprBdgtEntry3.SETRANGE(Position,getPostingCode(33020377,13));
                          GblMnprBdgtEntryList.SETTABLEVIEW(GblMnprBdgtEntry3);
                          GblMnprBdgtEntryList.RUNMODAL;
                        END;
                          */

                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        TotalPosition1 := 0;
        TotalPosition2 := 0;
        TotalPosition3 := 0;
        TotalPosition4 := 0;
        TotalPosition5 := 0;
        TotalPosition6 := 0;
        TotalPosition7 := 0;
        TotalPosition8 := 0;
        TotalPosition9 := 0;
        TotalPosition10 := 0;
        CurPosition1 := 0;
        CurPosition2 := 0;
        CurPosition3 := 0;
        CurPosition4 := 0;
        CurPosition5 := 0;
        CurPosition6 := 0;
        CurPosition7 := 0;
        CurPosition8 := 0;
        CurPosition9 := 0;
        CurPosition10 := 0;

        EVALUATE(VarInteger, TestYear);
        EVALUATE(VarInteger1, TestYear1);

        //Summing up no. of persion for Position 1.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
        //EVALUATE(VarInteger,TestYear);
        //EVALUATE(VarInteger1,TestYear1);
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 4));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        //GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
        IF GblMnprBdgtEntry4.FINDSET THEN BEGIN
            REPEAT
                TotalPosition1 := TotalPosition1 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate cur position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 4));
        IF GblMnprBdgtEntry4.FINDSET THEN BEGIN
            REPEAT
                CurPosition1 := CurPosition1 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 1" := CurPosition1 - TotalPosition1;
        //-----------------------------------------------------------------------------------------------------------

        //Summing up no. of persion for Position 2.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 5));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition2 := TotalPosition2 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 5));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition2 := CurPosition2 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 2" := CurPosition2 - TotalPosition2;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 3.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 6));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition3 := TotalPosition3 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 6));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition3 := CurPosition3 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 3" := CurPosition3 - TotalPosition3;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 4.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 7));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition4 := TotalPosition4 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 7));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition4 := CurPosition4 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 4" := CurPosition4 - TotalPosition4;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 5.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 8));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition5 := TotalPosition5 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 8));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition5 := CurPosition5 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 5" := CurPosition5 - TotalPosition5;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 6.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 9));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition6 := TotalPosition6 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 9));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition6 := CurPosition6 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 6" := CurPosition6 - TotalPosition6;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 7.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 10));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition7 := TotalPosition7 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 10));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition7 := CurPosition7 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 7" := CurPosition7 - TotalPosition7;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 8.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 11));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition8 := TotalPosition8 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 11));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition8 := CurPosition8 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 8" := CurPosition8 - TotalPosition8;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 9.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 12));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition9 := TotalPosition9 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 12));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition9 := CurPosition9 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 9" := CurPosition9 - TotalPosition9;
        //----------------------------------------------------------------------------------------------------------------------------
        //Summing up no. of persion for Position 10.
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 13));
        GblMnprBdgtEntry4.SETRANGE(TestYear, FORMAT(VarInteger - 1));
        GblMnprBdgtEntry4.SETRANGE(TestYear1, FORMAT(VarInteger1 - 1));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                TotalPosition10 := TotalPosition10 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        //sm to calculate previous position
        GblMnprBdgtEntry4.RESET;
        GblMnprBdgtEntry4.SETRANGE("Fiscal Year", "Fiscal Year");
        GblMnprBdgtEntry4.SETRANGE("Department Code", "Department Code");
        GblMnprBdgtEntry4.SETRANGE(Position, getPostingCode(33020377, 13));
        IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
            REPEAT
                CurPosition10 := CurPosition10 + GblMnprBdgtEntry4."No. of Person";
            UNTIL GblMnprBdgtEntry4.NEXT = 0;
        END;
        "Position 10" := CurPosition10 - TotalPosition10;
        //----------------------------------------------------------------------------------------------------------------------------
        /*


       //Summing up no. of persion for Position 3.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,6));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition3 := TotalPosition3 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 3" := TotalPosition3;
       END;

       //Summing up no. of persion for Position 4.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,7));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition4 := TotalPosition4 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 4" := TotalPosition4;
       END;

       //Summing up no. of persion for Position 5.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,8));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition5 := TotalPosition5 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 5" := TotalPosition5;
       END;

       //Summing up no. of persion for Position 6.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,9));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition6 := TotalPosition6 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 6" := TotalPosition6;
       END;

       //Summing up no. of persion for Position 7.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,10));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition7 := TotalPosition7 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 7" := TotalPosition7;
       END;

       //Summing up no. of persion for Position 8.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,11));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition8 := TotalPosition8 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 8" := TotalPosition8;
       END;

       //Summing up no. of persion for Position 9.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,12));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition9 := TotalPosition9 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 9" := TotalPosition9;
       END;

       //Summing up no. of persion for Position 10.
       GblMnprBdgtEntry4.RESET;
       //GblMnprBdgtEntry4.SETRANGE("Fiscal Year","Fiscal Year");
       GblMnprBdgtEntry4.SETRANGE("Department Code","Department Code");
       GblMnprBdgtEntry4.SETRANGE(Position,getPostingCode(33020377,13));
       GblMnprBdgtEntry4.SETFILTER(TestYear,'<=%1',TestYear);
       IF GblMnprBdgtEntry4.FIND('-') THEN BEGIN
         REPEAT
           TotalPosition10 := TotalPosition10 + GblMnprBdgtEntry4."No. of Person";
         UNTIL GblMnprBdgtEntry4.NEXT = 0;
         "Position 10" := TotalPosition10;
       END;
       */

    end;

    var
        GblMnprBdgtEntry: Record "33020378";
        GblMnprBdgtEntryList: Page "33020379";
        GblMnprBdgtEntry2: Record "33020378";
        GblMnprBdgtEntry3: Record "33020378";
        GblMnprBdgtEntry4: Record "33020378";
        TotalPosition1: Integer;
        TotalPosition2: Integer;
        TotalPosition3: Integer;
        TotalPosition4: Integer;
        TotalPosition5: Integer;
        TotalPosition6: Integer;
        TotalPosition7: Integer;
        TotalPosition8: Integer;
        TotalPosition9: Integer;
        TotalPosition10: Integer;
        VarInteger: Integer;
        VarInteger1: Integer;
        CurPosition1: Integer;
        CurPosition2: Integer;
        CurPosition3: Integer;
        CurPosition4: Integer;
        CurPosition5: Integer;
        CurPosition6: Integer;
        CurPosition7: Integer;
        CurPosition8: Integer;
        CurPosition9: Integer;
        CurPosition10: Integer;

    [Scope('Internal')]
    procedure getPostingCode(PrmTableNo: Integer; PrmFieldNo: Integer): Code[80]
    var
        LclVariableFieldSetup: Record "33020335";
    begin

        //Retrieving field name for budget entry.
        LclVariableFieldSetup.RESET;
        LclVariableFieldSetup.SETRANGE("Table No.", PrmTableNo);
        LclVariableFieldSetup.SETRANGE("Field No.", PrmFieldNo);
        IF LclVariableFieldSetup.FIND('-') THEN
            //MESSAGE('%1',LclVariableFieldSetup."Field Name");
          EXIT(LclVariableFieldSetup."Field Name");
    end;

    [Scope('Internal')]
    procedure getLastEntryNo(): Integer
    var
        LclMnprBdgtEntry: Record "33020378";
    begin
        //Retrieving last entry no.
        LclMnprBdgtEntry.RESET;
        IF LclMnprBdgtEntry.FIND('+') THEN
            EXIT(LclMnprBdgtEntry."Entry No.");
    end;
}

