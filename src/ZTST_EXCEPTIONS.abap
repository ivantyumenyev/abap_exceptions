*&---------------------------------------------------------------------*
*& Report ZTST_EXCEPTIONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztst_exceptions.

CLASS lcl_exceptions DEFINITION.
  PUBLIC SECTION.
    METHODS:
      call_static_check_exception
        RAISING cx_static_check,
      call_dynamic_check_exception,
      call_no_check_exception.
  PRIVATE SECTION.
    METHODS:
      call_int_static_check_excep
        RAISING cx_abap_invalid_name,
      call_int_no_check_exception.
ENDCLASS.

CLASS lcl_exceptions IMPLEMENTATION.
  METHOD call_static_check_exception.
    call_int_static_check_excep( ).
  ENDMETHOD.

  METHOD call_int_static_check_excep.
    RAISE EXCEPTION TYPE cx_abap_invalid_name.
  ENDMETHOD.

  METHOD call_dynamic_check_exception.
    TRY.
        DATA(lt_sflights) = VALUE sflight_tab1( ( ) ).
        DATA(ls_flight) = lt_sflights[ 1 ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lo_xline).
    ENDTRY.
  ENDMETHOD.

  METHOD call_no_check_exception.
    call_int_no_check_exception( ).
  ENDMETHOD.

  METHOD call_int_no_check_exception.
    RAISE EXCEPTION TYPE cx_salv_no_check.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(lo_exceptions) = NEW lcl_exceptions( ).

  "------------------------------------------------"
  " CX_STATIC_CHECK
  "------------------------------------------------"
  " Должны быть либо обработаны в методе,
  " либо метод должен иметь соответствующий интерфейс,
  " чтобы вызывающий её код мог обработать эту ситуацию.
  "
  " Обычно передается наверх
  " Статическая проверка выдаст предупреждение
  "------------------------------------------------"
  TRY .
      lo_exceptions->call_static_check_exception( ).
    CATCH cx_static_check INTO DATA(lo_xstatic).
  ENDTRY.

  "------------------------------------------------"
  " CX_DYNAMIC_CHECK
  "------------------------------------------------"
  " Обычно обрабатывается внутри метода без передачи наверх
  " Если хотим передать - необходимо явно указать в интерфейсе
  " Статическая проверка не выдает предупреждение
  "------------------------------------------------"
  TRY .
      lo_exceptions->call_dynamic_check_exception( ).
    CATCH cx_dynamic_check INTO DATA(lo_xdynamic).
  ENDTRY.

  "------------------------------------------------"
  " CX_NO_CHECK
  "------------------------------------------------"
  " Нельзя объявить в интерфейсе
  " Неявно передаются наверх
  " Могут неявно пройти всю цепочку вызова до самого верха
  " Статическая проверка не выдает предупреждение
  "------------------------------------------------"
  TRY .
      lo_exceptions->call_no_check_exception( ).
    CATCH cx_no_check INTO DATA(lo_xnocheck).
      WRITE: lo_xnocheck->get_text( ).
    CATCH cx_root INTO DATA(lo_xroot).
  ENDTRY.
