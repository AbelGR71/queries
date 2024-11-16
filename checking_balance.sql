--
--Parametros de filtro del reporte
DECLARE @rowid_account_auxiliary      INT = 0,
        @rowid_account_plan           INT = 0,
        @rowid_account_major          INT = 0,
        @level_account_major_filter   INT = 0,
        @rowid_cost_center_plan       INT = 0,
        @periodo_inicial              INT = 199901,
        @periodo_final                INT = 199912,
        @ano_saldo_inicial            INT = 0,
        @ano_saldo_final              INT = 0,
        @periodo_saldo_inicial        INT = 0,
        @periodo_saldo_final          INT = 0,
        @rowid_company_group          INT = 0,
        @rowid_company                INT = 0,
        @rowid_operation_center       INT = 0,
        @rowid_operation_center_group INT = 0,
        @rowid_regional               INT = 0,
        @rowid_business_unit          INT = 0,
        @rowid_business_unit_group    INT = 0;
--
--Parametros de presentacion del reporte
DECLARE @company_title                TINYINT = 1,--1=COMPANY_GROUP, 2=COMPANY
        @group_title1                 TINYINT = 0,--1=CO, 2=UN, 3=REGIONAL, 4=GRUPO CO, 5=GRUPO UN
        @group_title2                 TINYINT = 0,--1=CO, 2=UN, 3=REGIONAL, 4=GRUPO CO, 5=GRUPO UN
        @regional_detail              INT = 0,--0=No, 1=Si
        @orden_detail1                TINYINT = 0,--1=CO, 2=UN, 3=REGIONAL, 10=TERCERO SALDOS, 11=TERCERO SALDOS Y ACUMULADOS, 12=C.COSTOS MAYOR, 13=C.COSTOS AUXILIAR
        @orden_detail2                TINYINT = 0,--1=CO, 2=UN, 3=REGIONAL, 10=TERCERO SALDOS, 11=TERCERO SALDOS Y ACUMULADOS, 12=C.COSTOS MAYOR, 13=C.COSTOS AUXILIAR
        @orden_detail3                TINYINT = 0,--10=TERCERO SALDOS, 11=TERCERO SALDOS Y ACUMULADOS, 12=C.COSTOS MAYOR, 13=C.COSTOS AUXILIAR
        @orden_detail4                TINYINT = 0,--10=TERCERO SALDOS, 11=TERCERO SALDOS Y ACUMULADOS, 12=C.COSTOS MAYOR, 13=C.COSTOS AUXILIAR
        @level_account_major          INT = 11,--1 a 10 para mayores, 11 a nivel de auxiliar
        @level_cost_center_major      INT = 0,--1 a 10 para mayores, 11 a nivel de auxiliar
        @title_company_group          VARCHAR(250) = '',
        @title_regional               VARCHAR(250) = '',
        @title_operation_center_group VARCHAR(250) = '',
        @title_business_unit_group    VARCHAR(250) = '';

--
--
SELECT @ano_saldo_inicial = Floor(@periodo_inicial / 100),
       @ano_saldo_final = Floor(@periodo_final / 100),
       @periodo_saldo_inicial = ( @ano_saldo_inicial + .01 ) * 100,
       @periodo_saldo_final = CASE
                                WHEN @periodo_inicial - 1 < @periodo_saldo_inicial THEN @periodo_saldo_inicial
                                ELSE @periodo_inicial - 1
                              END;

--
--Grupo de compañias
SELECT @rowid_company_group = e04100.c04100_rowid,
       @title_company_group = Concat(e04100.c04100_id, '-', e04100.c04100_name)
FROM   e04100_company_group e04100
WHERE  e04100.c04100_id = '1';

--
--Compañias
SELECT @rowid_company = e04101.c04101_rowid
FROM   e04101_company e04101
WHERE  e04101.c04101_rowid_company_group = @rowid_company_group
       AND e04101.c04101_id = ''; --'1'

--
--planes de cuentas
SELECT @rowid_account_plan = e04210.c04210_rowid
FROM   e04210_account_plan e04210
WHERE  e04210.c04210_rowid_company_group = @rowid_company_group
       AND e04210.c04210_id = 'PUC';

--
--Mayores de cuentas
SELECT @rowid_account_major = e04212.c04212_rowid,
       @level_account_major_filter = e04212.c04212_level
FROM   e04212_account_major e04212
WHERE  e04212.c04212_rowid_company_group = @rowid_company_group
       AND e04212.c04212_id = ''; --'110510'

--
--Auxiliares de cuentas
SELECT @rowid_account_auxiliary = e04213.c04213_rowid
FROM   e04213_account_auxiliary e04213
WHERE  e04213.c04213_rowid_company_group = @rowid_company_group
       AND e04213.c04213_id = ''; --'11051001'

--
--planes de centro de costo
SELECT TOP (1) @rowid_cost_center_plan = e04230.c04230_rowid
FROM   e04230_cost_center_plan e04230
WHERE  e04230.c04230_rowid_company_group = @rowid_company_group

--
--Regionales
SELECT @rowid_regional = e04150.c04150_rowid,
       @title_regional = Concat(e04150.c04150_id, '-', e04150.c04150_name)
FROM   e04150_regional e04150
WHERE  e04150.c04150_rowid_company_group = @rowid_company_group
       AND e04150.c04150_id = ''; --'01'

--
--Centros de operacion
SELECT @rowid_operation_center = e04160.c04160_rowid
FROM   e04160_operation_center e04160
WHERE  e04160.c04160_rowid_company_group = @rowid_company_group
       AND e04160.c04160_id = ''; --'01'

--
--Grupos de centros de operacion
SELECT @rowid_operation_center_group = e04166.c04166_rowid,
       @title_operation_center_group = Concat(e04166.c04166_id, '-', e04166.c04166_name)
FROM   e04166_operation_center_group e04166
WHERE  e04166.c04166_rowid_company_group = @rowid_company_group
       AND e04166.c04166_id = ''; --''

--
--Unidades de negocio
SELECT @rowid_business_unit = e04180.c04180_rowid
FROM   e04180_business_unit e04180
WHERE  e04180.c04180_rowid_company_group = @rowid_company_group
       AND e04180.c04180_id = ''; --'01';

--
--Grupos de unidades de negocio
SELECT @rowid_business_unit_group = e04181.c04181_rowid,
       @title_operation_center_group = Concat(e04181.c04181_id, '-', e04181.c04181_name)
FROM   e04181_business_unit_group e04181
WHERE  e04181.c04181_rowid_company_group = @rowid_company_group
       AND e04181.c04181_id = ''; --'';

--
--
SELECT @rowid_company_group   rowid_company_group,
       @rowid_account_plan    rowid_account_plan,
       @ano_saldo_inicial     ano_saldo_inicial,
       @ano_saldo_final       ano_saldo_final,
       @periodo_saldo_inicial periodo_saldo_inicial,
       @periodo_saldo_final   periodo_saldo_final,
       @periodo_inicial       periodo_inicial,
       @periodo_final         periodo_final;

--
--
;
WITH cte_summary
     AS (SELECT e10090.c10090_rowid rowid_summary,
                Sum (CASE
                       WHEN e04270.c04270_id = @ano_saldo_inicial THEN e10091.c10091_initial_balance
                       ELSE 0
                     END)           initial_balance,
                Sum (CASE
                       WHEN e04271.c04271_id BETWEEN @periodo_saldo_inicial AND @periodo_saldo_final THEN e10092.c10092_debit_value - e10092.c10092_credit_value
                       ELSE 0
                     END)           neto_initial_balance,
                Sum (CASE
                       WHEN e04271.c04271_id BETWEEN @periodo_inicial AND @periodo_final THEN Isnull(e10092.c10092_debit_value, 0)
                       ELSE 0
                     END)           debit_value,
                Sum (CASE
                       WHEN e04271.c04271_id BETWEEN @periodo_inicial AND @periodo_final THEN Isnull(e10092.c10092_credit_value, 0)
                       ELSE 0
                     END)           credit_value,
                Sum (CASE
                       WHEN e04270.c04270_id = @ano_saldo_inicial THEN e10091.c10091_foreign_initial_balance
                       ELSE 0
                     END)           foreign_initial_balance,
                Sum (CASE
                       WHEN e04271.c04271_id BETWEEN @periodo_saldo_inicial AND @periodo_saldo_final THEN e10092.c10092_foreign_debit_value - e10092.c10092_foreign_credit_value
                       ELSE 0
                     END)           foreign_neto_initial_balance,
                Sum (CASE
                       WHEN e04271.c04271_id BETWEEN @periodo_inicial AND @periodo_final THEN Isnull(e10092.c10092_foreign_debit_value, 0)
                       ELSE 0
                     END)           foreign_debit_value,
                Sum (CASE
                       WHEN e04271.c04271_id BETWEEN @periodo_inicial AND @periodo_final THEN Isnull(e10092.c10092_foreign_credit_value, 0)
                       ELSE 0
                     END)           foreign_credit_value
         FROM   e10090_summary e10090
                --Filtro de una mayor
                --INNER JOIN e04216_account_tree e04216
                --        ON e04216.c04216_rowid_account_auxiliary = e10090.c10090_rowid_account_auxiliary
                --           AND e04216.c04216_rowid_account_plan = @rowid_account_plan
                --           AND CASE
                --                 WHEN @level_account_major_filter = 1 THEN e04216.c04216_rowid_account_major_level1
                --                 WHEN @level_account_major_filter = 2 THEN e04216.c04216_rowid_account_major_level2
                --                 WHEN @level_account_major_filter = 3 THEN e04216.c04216_rowid_account_major_level3
                --                 WHEN @level_account_major_filter = 4 THEN e04216.c04216_rowid_account_major_level4
                --                 WHEN @level_account_major_filter = 5 THEN e04216.c04216_rowid_account_major_level5
                --                 WHEN @level_account_major_filter = 6 THEN e04216.c04216_rowid_account_major_level6
                --                 WHEN @level_account_major_filter = 7 THEN e04216.c04216_rowid_account_major_level7
                --                 WHEN @level_account_major_filter = 8 THEN e04216.c04216_rowid_account_major_level8
                --                 WHEN @level_account_major_filter = 9 THEN e04216.c04216_rowid_account_major_level9
                --                 WHEN @level_account_major_filter = 10 THEN e04216.c04216_rowid_account_major_level10
                --               END = @rowid_account_major
                --Filtro de una regional
                --INNER JOIN e04160_operation_center e04160
                --ON e04160.c04160_rowid = e10090.c10090_rowid_operation_center
                -- AND e04160.c04160_rowid_regional = @rowid_regional
                --Filtro de un grupo de centros de operacion
                --INNER JOIN e04167_operation_center_group_detail e04167
                --        ON e04167.c04167_rowid_operation_center_group = @rowid_operation_center_group
                --           AND e04167.c04167_rowid_operation_center = e10090.c10090_rowid_operation_center
                --Filtro de un grupo de unidades de negocio
                --INNER JOIN e04182_business_unit_group_detail e04182
                --        ON e04182.c04182_rowid_business_unit_group = @rowid_business_unit_group
                --           AND e04182.c04182_rowid_business_unit = e10090.c10090_rowid_business_unit
                INNER JOIN e04101_company e04101
                        ON e04101.c04101_rowid = c10090_rowid_company
                           AND e04101.c04101_rowid_company_group = @rowid_company_group
                LEFT JOIN e10091_summary_by_book e10091
                       ON e10091.c10091_rowid_summary = e10090.c10090_rowid
                LEFT JOIN e04270_fiscal_year e04270
                       ON e04270.c04270_rowid = c10091_rowid_fiscal_year
                          AND e04270.c04270_id BETWEEN @ano_saldo_inicial AND @ano_saldo_final
                LEFT JOIN e10092_summary_by_book_period e10092
                       ON e10092.c10092_rowid_summary_by_book = e10091.c10091_rowid
                LEFT JOIN e04271_fiscal_period e04271
                       ON e04271.c04271_rowid = c10092_rowid_fiscal_period
                          AND e04271.c04271_id BETWEEN @periodo_saldo_inicial AND @periodo_final
         WHERE  ( e10090.c10090_rowid_company = @rowid_company
                   OR @rowid_company = 0 ) --Filtro de una compañia
                AND ( @rowid_account_auxiliary = e10090.c10090_rowid_account_auxiliary
                       OR @rowid_account_auxiliary = 0 ) --Filtro de una auxiliar
                AND ( @rowid_operation_center = e10090.c10090_rowid_operation_center
                       OR @rowid_operation_center = 0 ) --Filtro de un centro de operacion
                AND ( @rowid_business_unit = e10090.c10090_rowid_business_unit
                       OR @rowid_business_unit = 0 ) --Filtro de una unidad de negocio
         GROUP  BY e10090.c10090_rowid),
     cte_summary_detail
     AS (SELECT CASE
                  WHEN @company_title = 1 THEN @title_company_group
                  WHEN @company_title = 2 THEN Concat(e04101.c04101_id, '-', e04101.c04101_name)
                END                                    company_title,
                CASE
                  WHEN @group_title1 = 0 THEN NULL
                  WHEN @group_title1 = 1 THEN Concat(e04160.c04160_id, '-', e04160.c04160_name)
                  WHEN @group_title1 = 2 THEN Concat(e04180.c04180_id, '-', e04180.c04180_name)
                  WHEN @group_title1 = 3
                       AND @regional_detail = 0 THEN @title_regional
                  WHEN @group_title1 = 3
                       AND @regional_detail = 1 THEN Concat(e04160.c04160_id, '-', e04160.c04160_name)
                  WHEN @group_title1 = 4 THEN @title_operation_center_group
                  WHEN @group_title1 = 5 THEN @title_business_unit_group
                END                                    group_title1,--1=CO, 2=UN, 3=REGIONAL, 4=GRUPO CO,  5=GRUPO UN
                CASE
                  WHEN @group_title2 = 0 THEN NULL
                  WHEN @group_title2 = 1 THEN Concat(e04160.c04160_id, '-', e04160.c04160_name)
                  WHEN @group_title2 = 2 THEN Concat(e04180.c04180_id, '-', e04180.c04180_name)
                  WHEN @group_title2 = 3
                       AND @regional_detail = 0 THEN @title_regional
                  WHEN @group_title2 = 3
                       AND @regional_detail = 1 THEN Concat(e04160.c04160_id, '-', e04160.c04160_name)
                  WHEN @group_title2 = 4 THEN @title_operation_center_group
                  WHEN @group_title2 = 5 THEN @title_business_unit_group
                END                                    group_title2,--1=CO, 2=UN, 3=REGIONAL, 4=GRUPO CO, 5=GRUPO UN
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 1
                       AND @level_account_major >= 1 THEN e04216.c04216_id_account_major_level1
                  ELSE NULL
                END                                    id_account_major_level1,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 1
                       AND @level_account_major >= 1 THEN e04216.c04216_name_account_major_level1
                  ELSE NULL
                END                                    name_account_major_level1,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 2
                       AND @level_account_major >= 2 THEN e04216.c04216_id_account_major_level2
                  ELSE NULL
                END                                    id_account_major_level2,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 2
                       AND @level_account_major >= 2 THEN e04216.c04216_name_account_major_level2
                  ELSE NULL
                END                                    name_account_major_level2,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 3
                       AND @level_account_major >= 3 THEN e04216.c04216_id_account_major_level3
                  ELSE NULL
                END                                    id_account_major_level3,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 3
                       AND @level_account_major >= 3 THEN e04216.c04216_name_account_major_level3
                  ELSE NULL
                END                                    name_account_major_level3,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 4
                       AND @level_account_major >= 4 THEN e04216.c04216_id_account_major_level4
                  ELSE NULL
                END                                    id_account_major_level4,
                CASE
                  WHEN @rowid_account_auxiliary <> 0 THEN NULL
                  WHEN @level_account_major_filter <= 4
                       AND @level_account_major >= 4 THEN e04216.c04216_name_account_major_level4
                  ELSE NULL
                END                                    name_account_major_level4,
                CASE
                  WHEN @level_account_major = 11 THEN e04216.c04216_id_account_auxiliary
                  ELSE NULL
                END                                    id_account_auxiliary,
                ----
                CASE
                  WHEN @orden_detail1 = 0 THEN NULL
                  WHEN @orden_detail1 = 1 THEN e04160.c04160_id
                  WHEN @orden_detail1 = 2 THEN e04180.c04180_id
                  WHEN @orden_detail1 = 3 THEN e04150.c04150_id
                END                                    aditional_column1,--1=CO, 2=UN, 3=REGIONAL
                ----
                CASE
                  WHEN @orden_detail2 = 0 THEN NULL
                  WHEN @orden_detail2 = 1 THEN e04160.c04160_id
                  WHEN @orden_detail2 = 2 THEN e04180.c04180_id
                  WHEN @orden_detail2 = 3 THEN e04150.c04150_id
                END                                    aditional_column2,--1=CO, 2=UN, 3=REGIONAL
                ----
                CASE
                  WHEN @orden_detail1 IN ( 10, 11, 12, 13 ) THEN
                    CASE
                      WHEN @orden_detail1 = 10
                           AND e04213.c04213_third_party_indicator IN( 1, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail1 = 11
                           AND e04213.c04213_third_party_indicator IN( 1, 2, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail1 = 12 THEN
                        CASE
                          WHEN @level_cost_center_major = 1 THEN ( e04236.c04236_id_cost_center_major_level1
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level1 )
                          WHEN @level_cost_center_major = 2 THEN ( e04236.c04236_id_cost_center_major_level2
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level2 )
                          WHEN @level_cost_center_major = 3 THEN ( e04236.c04236_id_cost_center_major_level3
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level3 )
                          WHEN @level_cost_center_major = 4 THEN ( e04236.c04236_id_cost_center_major_level4
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level4 )
                          WHEN @level_cost_center_major = 5 THEN ( e04236.c04236_id_cost_center_major_level5
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level5 )
                          WHEN @level_cost_center_major = 6 THEN ( e04236.c04236_id_cost_center_major_level6
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level6 )
                          WHEN @level_cost_center_major = 7 THEN ( e04236.c04236_id_cost_center_major_level7
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level7 )
                          WHEN @level_cost_center_major = 8 THEN ( e04236.c04236_id_cost_center_major_level8
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level8 )
                          WHEN @level_cost_center_major = 9 THEN ( e04236.c04236_id_cost_center_major_level9
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level9 )
                          WHEN @level_cost_center_major = 10 THEN ( e04236.c04236_id_cost_center_major_level10
                                                                    + '-'
                                                                    + e04236.c04236_name_cost_center_major_level10 )
                        END
                      WHEN @orden_detail1 = 13 THEN ( e04236.c04236_id_cost_center_auxiliary
                                                      + '-'
                                                      + e04236.c04236_name_cost_center_auxiliary )
                    END
                  WHEN @orden_detail2 IN ( 10, 11, 12, 13 ) THEN
                    CASE
                      WHEN @orden_detail2 = 10
                           AND e04213.c04213_third_party_indicator IN( 1, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail2 = 11
                           AND e04213.c04213_third_party_indicator IN( 1, 2, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail2 = 12 THEN
                        CASE
                          WHEN @level_cost_center_major = 1 THEN ( e04236.c04236_id_cost_center_major_level1
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level1 )
                          WHEN @level_cost_center_major = 2 THEN ( e04236.c04236_id_cost_center_major_level2
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level2 )
                          WHEN @level_cost_center_major = 3 THEN ( e04236.c04236_id_cost_center_major_level3
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level3 )
                          WHEN @level_cost_center_major = 4 THEN ( e04236.c04236_id_cost_center_major_level4
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level4 )
                          WHEN @level_cost_center_major = 5 THEN ( e04236.c04236_id_cost_center_major_level5
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level5 )
                          WHEN @level_cost_center_major = 6 THEN ( e04236.c04236_id_cost_center_major_level6
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level6 )
                          WHEN @level_cost_center_major = 7 THEN ( e04236.c04236_id_cost_center_major_level7
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level7 )
                          WHEN @level_cost_center_major = 8 THEN ( e04236.c04236_id_cost_center_major_level8
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level8 )
                          WHEN @level_cost_center_major = 9 THEN ( e04236.c04236_id_cost_center_major_level9
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level9 )
                          WHEN @level_cost_center_major = 10 THEN ( e04236.c04236_id_cost_center_major_level10
                                                                    + '-'
                                                                    + e04236.c04236_name_cost_center_major_level10 )
                        END
                      WHEN @orden_detail2 = 13 THEN ( e04236.c04236_id_cost_center_auxiliary
                                                      + '-'
                                                      + e04236.c04236_name_cost_center_auxiliary )
                    END
                  WHEN @orden_detail3 IN ( 10, 11, 12, 13 ) THEN
                    CASE
                      WHEN @orden_detail3 = 10
                           AND e04213.c04213_third_party_indicator IN( 1, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail3 = 11
                           AND e04213.c04213_third_party_indicator IN( 1, 2, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail3 = 12 THEN
                        CASE
                          WHEN @level_cost_center_major = 1 THEN ( e04236.c04236_id_cost_center_major_level1
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level1 )
                          WHEN @level_cost_center_major = 2 THEN ( e04236.c04236_id_cost_center_major_level2
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level2 )
                          WHEN @level_cost_center_major = 3 THEN ( e04236.c04236_id_cost_center_major_level3
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level3 )
                          WHEN @level_cost_center_major = 4 THEN ( e04236.c04236_id_cost_center_major_level4
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level4 )
                          WHEN @level_cost_center_major = 5 THEN ( e04236.c04236_id_cost_center_major_level5
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level5 )
                          WHEN @level_cost_center_major = 6 THEN ( e04236.c04236_id_cost_center_major_level6
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level6 )
                          WHEN @level_cost_center_major = 7 THEN ( e04236.c04236_id_cost_center_major_level7
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level7 )
                          WHEN @level_cost_center_major = 8 THEN ( e04236.c04236_id_cost_center_major_level8
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level8 )
                          WHEN @level_cost_center_major = 9 THEN ( e04236.c04236_id_cost_center_major_level9
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level9 )
                          WHEN @level_cost_center_major = 10 THEN ( e04236.c04236_id_cost_center_major_level10
                                                                    + '-'
                                                                    + e04236.c04236_name_cost_center_major_level10 )
                        END
                      WHEN @orden_detail3 = 13 THEN ( e04236.c04236_id_cost_center_auxiliary
                                                      + '-'
                                                      + e04236.c04236_name_cost_center_auxiliary )
                    END
                  ELSE NULL
                END                                    aditional_row1,--10=TERCERO SALDOS, 11=TERCERO SALDOS Y ACUMULADOS, 12=C.COSTOS MAYOR, 13=C.COSTOS AUXILIAR
                ----
                CASE
                  WHEN @orden_detail4 IN ( 10, 11, 12, 13 ) THEN
                    CASE
                      WHEN @orden_detail4 = 10
                           AND e04213.c04213_third_party_indicator IN( 1, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail4 = 11
                           AND e04213.c04213_third_party_indicator IN( 1, 2, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail4 = 12 THEN
                        CASE
                          WHEN @level_cost_center_major = 1 THEN ( e04236.c04236_id_cost_center_major_level1
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level1 )
                          WHEN @level_cost_center_major = 2 THEN ( e04236.c04236_id_cost_center_major_level2
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level2 )
                          WHEN @level_cost_center_major = 3 THEN ( e04236.c04236_id_cost_center_major_level3
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level3 )
                          WHEN @level_cost_center_major = 4 THEN ( e04236.c04236_id_cost_center_major_level4
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level4 )
                          WHEN @level_cost_center_major = 5 THEN ( e04236.c04236_id_cost_center_major_level5
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level5 )
                          WHEN @level_cost_center_major = 6 THEN ( e04236.c04236_id_cost_center_major_level6
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level6 )
                          WHEN @level_cost_center_major = 7 THEN ( e04236.c04236_id_cost_center_major_level7
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level7 )
                          WHEN @level_cost_center_major = 8 THEN ( e04236.c04236_id_cost_center_major_level8
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level8 )
                          WHEN @level_cost_center_major = 9 THEN ( e04236.c04236_id_cost_center_major_level9
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level9 )
                          WHEN @level_cost_center_major = 10 THEN ( e04236.c04236_id_cost_center_major_level10
                                                                    + '-'
                                                                    + e04236.c04236_name_cost_center_major_level10 )
                        END
                      WHEN @orden_detail4 = 13 THEN ( e04236.c04236_id_cost_center_auxiliary
                                                      + '-'
                                                      + e04236.c04236_name_cost_center_auxiliary )
                    END
                  WHEN @orden_detail3 IN ( 10, 11, 12, 13 ) THEN
                    CASE
                      WHEN @orden_detail3 = 10
                           AND e04213.c04213_third_party_indicator IN( 1, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail3 = 11
                           AND e04213.c04213_third_party_indicator IN( 1, 2, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail3 = 12 THEN
                        CASE
                          WHEN @level_cost_center_major = 1 THEN ( e04236.c04236_id_cost_center_major_level1
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level1 )
                          WHEN @level_cost_center_major = 2 THEN ( e04236.c04236_id_cost_center_major_level2
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level2 )
                          WHEN @level_cost_center_major = 3 THEN ( e04236.c04236_id_cost_center_major_level3
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level3 )
                          WHEN @level_cost_center_major = 4 THEN ( e04236.c04236_id_cost_center_major_level4
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level4 )
                          WHEN @level_cost_center_major = 5 THEN ( e04236.c04236_id_cost_center_major_level5
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level5 )
                          WHEN @level_cost_center_major = 6 THEN ( e04236.c04236_id_cost_center_major_level6
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level6 )
                          WHEN @level_cost_center_major = 7 THEN ( e04236.c04236_id_cost_center_major_level7
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level7 )
                          WHEN @level_cost_center_major = 8 THEN ( e04236.c04236_id_cost_center_major_level8
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level8 )
                          WHEN @level_cost_center_major = 9 THEN ( e04236.c04236_id_cost_center_major_level9
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level9 )
                          WHEN @level_cost_center_major = 10 THEN ( e04236.c04236_id_cost_center_major_level10
                                                                    + '-'
                                                                    + e04236.c04236_name_cost_center_major_level10 )
                        END
                      WHEN @orden_detail3 = 13 THEN ( e04236.c04236_id_cost_center_auxiliary
                                                      + '-'
                                                      + e04236.c04236_name_cost_center_auxiliary )
                    END
                  WHEN @orden_detail2 IN ( 10, 11, 12, 13 ) THEN
                    CASE
                      WHEN @orden_detail2 = 10
                           AND e04213.c04213_third_party_indicator IN( 1, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail2 = 11
                           AND e04213.c04213_third_party_indicator IN( 1, 2, 3 ) THEN ( e04410.c04410_id + '-' + e04410.c04410_name )
                      WHEN @orden_detail2 = 12 THEN
                        CASE
                          WHEN @level_cost_center_major = 1 THEN ( e04236.c04236_id_cost_center_major_level1
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level1 )
                          WHEN @level_cost_center_major = 2 THEN ( e04236.c04236_id_cost_center_major_level2
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level2 )
                          WHEN @level_cost_center_major = 3 THEN ( e04236.c04236_id_cost_center_major_level3
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level3 )
                          WHEN @level_cost_center_major = 4 THEN ( e04236.c04236_id_cost_center_major_level4
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level4 )
                          WHEN @level_cost_center_major = 5 THEN ( e04236.c04236_id_cost_center_major_level5
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level5 )
                          WHEN @level_cost_center_major = 6 THEN ( e04236.c04236_id_cost_center_major_level6
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level6 )
                          WHEN @level_cost_center_major = 7 THEN ( e04236.c04236_id_cost_center_major_level7
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level7 )
                          WHEN @level_cost_center_major = 8 THEN ( e04236.c04236_id_cost_center_major_level8
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level8 )
                          WHEN @level_cost_center_major = 9 THEN ( e04236.c04236_id_cost_center_major_level9
                                                                   + '-'
                                                                   + e04236.c04236_name_cost_center_major_level9 )
                          WHEN @level_cost_center_major = 10 THEN ( e04236.c04236_id_cost_center_major_level10
                                                                    + '-'
                                                                    + e04236.c04236_name_cost_center_major_level10 )
                        END
                      WHEN @orden_detail2 = 13 THEN ( e04236.c04236_id_cost_center_auxiliary
                                                      + '-'
                                                      + e04236.c04236_name_cost_center_auxiliary )
                    END
                  ELSE NULL
                END                                    aditional_row2,--10=TERCERO SALDOS, 11=TERCERO SALDOS Y ACUMULADOS, 12=C.COSTOS MAYOR, 13=C.COSTOS AUXILIAR
                ( cte_summary.initial_balance
                  + cte_summary.neto_initial_balance ) initial_balance,
                cte_summary.debit_value,
                cte_summary.credit_value,
                ( cte_summary.foreign_initial_balance
                  + cte_summary.neto_initial_balance ) foreign_initial_balance,
                cte_summary.foreign_debit_value,
                cte_summary.foreign_credit_value
         FROM   cte_summary
                INNER JOIN e10090_summary e10090
                        ON e10090.c10090_rowid = cte_summary.rowid_summary
                INNER JOIN e04216_account_tree e04216
                        ON e04216.c04216_rowid_account_plan = @rowid_account_plan
                           AND e04216.c04216_rowid_account_auxiliary = e10090.c10090_rowid_account_auxiliary
                --Obtener informacion de la compañia, solo si se detalla en el titulo
                INNER JOIN e04101_company e04101
                        ON e04101.c04101_rowid = e10090.c10090_rowid_company
                --Obtener informacion de centro de operacion o regional, solo si se detalla, ya sea en el titulo o en el cuerpo
                INNER JOIN e04160_operation_center e04160
                        ON e04160.c04160_rowid = e10090.c10090_rowid_operation_center
                --Obtener informacion de la regional, solo si se detalla, ya sea en el titulo o en el cuerpo
                INNER JOIN e04150_regional e04150
                        ON e04150.c04150_rowid = e04160.c04160_rowid_regional
                --Obtener informacion de la unidad de negocio, solo si se detalla, ya sea en el titulo o en el cuerpo
                INNER JOIN e04180_business_unit e04180
                        ON e04180.c04180_rowid = e10090.c10090_rowid_business_unit
                --Obtener informacion del tercero, solo si se detalla en el cuerpo
                INNER JOIN e04213_account_auxiliary e04213
                        ON e04213.c04213_rowid = e10090.c10090_rowid_account_auxiliary
                LEFT JOIN e04410_third_party e04410
                       ON e04410.c04410_rowid = e10090.c10090_rowid_third_party
                --Obtener informacion del centro de costo, solo si se detalla en el cuerpo
                LEFT JOIN e04236_cost_center_tree e04236
                       ON e04236.c04236_rowid_cost_center_plan = @rowid_cost_center_plan
                          AND e04236.c04236_rowid_cost_center_auxiliary = e10090.c10090_rowid_cost_center_auxiliary)
--
SELECT company_title,
       group_title1,
       group_title2,
       id_account_major_level1,
       name_account_major_level1,
       id_account_major_level2,
       name_account_major_level2,
       id_account_major_level3,
       name_account_major_level3,
       id_account_major_level4,
       name_account_major_level4,
       id_account_auxiliary,
       aditional_column1,
       aditional_column2,
       NULL                         aditional_row1,
       NULL                         aditional_row2,
       Sum(initial_balance)         initial_balance,
       Sum(debit_value)             debit_value,
       Sum(credit_value)            credit_value,
       Sum(foreign_initial_balance) foreign_initial_balance,
       Sum(foreign_debit_value)     foreign_debit_value,
       Sum(foreign_credit_value)    foreign_credit_value,
       10                           report_order
FROM   cte_summary_detail
GROUP  BY company_title,
          group_title1,
          group_title2,
          id_account_major_level1,
          name_account_major_level1,
          id_account_major_level2,
          name_account_major_level2,
          id_account_major_level3,
          name_account_major_level3,
          id_account_major_level4,
          name_account_major_level4,
          id_account_auxiliary,
          aditional_column1,
          aditional_column2
UNION ALL
SELECT company_title,
       group_title1,
       group_title2,
       id_account_major_level1,
       name_account_major_level1,
       id_account_major_level2,
       name_account_major_level2,
       id_account_major_level3,
       name_account_major_level3,
       id_account_major_level4,
       name_account_major_level4,
       id_account_auxiliary,
       aditional_column1,
       aditional_column2,
       aditional_row1,
       NULL                         aditional_row2,
       Sum(initial_balance)         initial_balance,
       Sum(debit_value)             debit_value,
       Sum(credit_value)            credit_value,
       Sum(foreign_initial_balance) foreign_initial_balance,
       Sum(foreign_debit_value)     foreign_debit_value,
       Sum(foreign_credit_value)    foreign_credit_value,
       20                           report_order
FROM   cte_summary_detail
WHERE  aditional_row1 IS NOT NULL
GROUP  BY company_title,
          group_title1,
          group_title2,
          id_account_major_level1,
          name_account_major_level1,
          id_account_major_level2,
          name_account_major_level2,
          id_account_major_level3,
          name_account_major_level3,
          id_account_major_level4,
          name_account_major_level4,
          id_account_auxiliary,
          aditional_column1,
          aditional_column2,
          aditional_row1
UNION ALL
SELECT company_title,
       group_title1,
       group_title2,
       id_account_major_level1,
       name_account_major_level1,
       id_account_major_level2,
       name_account_major_level2,
       id_account_major_level3,
       name_account_major_level3,
       id_account_major_level4,
       name_account_major_level4,
       id_account_auxiliary,
       aditional_column1,
       aditional_column2,
       aditional_row1,
       aditional_row2,
       Sum(initial_balance)         initial_balance,
       Sum(debit_value)             debit_value,
       Sum(credit_value)            credit_value,
       Sum(foreign_initial_balance) foreign_initial_balance,
       Sum(foreign_debit_value)     foreign_debit_value,
       Sum(foreign_credit_value)    foreign_credit_value,
       30                           report_order
FROM   cte_summary_detail
WHERE  aditional_row1 IS NOT NULL
       AND aditional_row2 IS NOT NULL
GROUP  BY company_title,
          group_title1,
          group_title2,
          id_account_major_level1,
          name_account_major_level1,
          id_account_major_level2,
          name_account_major_level2,
          id_account_major_level3,
          name_account_major_level3,
          id_account_major_level4,
          name_account_major_level4,
          id_account_auxiliary,
          aditional_column1,
          aditional_column2,
          aditional_row1,
          aditional_row2
ORDER  BY company_title,
          group_title1,
          group_title2,
          id_account_major_level1,
          name_account_major_level1,
          id_account_major_level2,
          name_account_major_level2,
          id_account_major_level3,
          name_account_major_level3,
          id_account_major_level4,
          name_account_major_level4,
          id_account_auxiliary,
          aditional_column1,
          aditional_column2,
          aditional_row1,
          aditional_row2,
          report_order; 


