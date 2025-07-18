#Область ПрограммныйИнтерфейс

#Область ФункцииРаботыGS1

// Разобрать строку штрихкода в соответствии со стандартом GS1.
//
// Параметры:
//  Штрихкод - Строка - значение штрихкода.
//
// Возвращаемое значение:
//  Структура.
Функция РазобратьСтрокуШтрихкодаGS1(Знач Штрихкод) Экспорт;
	
	РезультатРазбора = МенеджерОборудованияМаркировкаКлиентСервер.НовыйРезультатРазбораСтрокиШтрихкодаGS1();
	
	КодыGS1 = КодыGS1();
	
	Если СтрНачинаетсяС(Штрихкод, "(") Тогда
		МенеджерОборудованияМаркировкаКлиентСервер.РазобратьСтрокуШтрихкодаGS1СоСкобками(Штрихкод, РезультатРазбора, КодыGS1);
	Иначе
		Разделитель = ОбщегоНазначенияБПОКлиентСервер.РазделительGS1();
		ЧастиШтрихкода = СтрРазделить(Штрихкод, Разделитель, Ложь);
		Для Каждого ЧастьБезРазделителей Из ЧастиШтрихкода Цикл
			МенеджерОборудованияМаркировкаКлиентСервер.РазобратьСтрокуШтрихкодаGS1Служебный(ЧастьБезРазделителей, РезультатРазбора, КодыGS1);
		КонецЦикла;
	КонецЕсли;
	
	Возврат РезультатРазбора;
	
КонецФункции

#КонецОбласти

#Область ФункцииМаркировкиПродукции

// Разобрать штриховой код товара.
// 
// Параметры:
//  Штрихкод - Строка - Штрихкод
//  ШтрихкодВBase64 - Булево - Штрихкод в base64
// 
// Возвращаемое значение:
//  Структура - Разобрать штриховой код товара:
//   * Разобран - Булево -
//   * ОписаниеОшибки - СТрока
//   * ПредставлениеШтрихкода - Строка -
//   * ДанныеШтрихкода - Строка -
//   * ТипИдентификатораТовара - ПеречислениеСсылка.ТипыИдентификаторовТовараККТ -
//   * GTIN - Строка -  
//   * СерийныйНомер - Строка - 
//   * EAN - Строка - 
//   * РеквизитКодаТовараHEX - Строка - 
//   * РеквизитКодаТовара - Строка - 
//   * ИдентифицируетЭкземпляр - Булево -
//   * ПотребительскаяУпаковкаТабачнойПродукции - Булево -
//   * ШтрихкодBase64 - Булево - 
//   * НаименованиеРеквизита - Строка - 
//
Функция РазобратьШтриховойКодТовара(Знач Штрихкод, Знач ШтрихкодВBase64 = Ложь) Экспорт;
	
	КодыGS1 = КодыGS1();
	Возврат МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовараСлужебная(Штрихкод, ШтрихкодВBase64, КодыGS1);
	
КонецФункции

// Коды g s1.
// 
// Возвращаемое значение:
//  Соответствие из Строка - Коды gs1
Функция КодыGS1() Экспорт
	
	Возврат МенеджерОборудованияМаркировкаКлиентПовтИсп.КодыGS1Служебный();
	
КонецФункции

#КонецОбласти


// Открытие форму списка операций проверки КМ
//
// Параметры:
//  ПараметрКоманды - Произвольный - источник, в котором реализована команда
//  ПараметрыВыполненияКоманды - ПараметрыВыполненияКоманды
//
Процедура ОткрытьОперацииПроверкиКМ(ПараметрКоманды, ПараметрыВыполненияКоманды) Экспорт
	
	// ++ НеМобильноеПриложение
#Если Не МобильноеПриложениеКлиент Тогда 
	// Замер производительности.
	КлючеваяОперация = "ОбщийМодуль.МенеджерОборудованияКлиент.ОткрытьОперацииПроверкиКМ";
	ОбщегоНазначенияБПОКлиент.ЗамерВремениБПО(КлючеваяОперация, Неопределено, Ложь, Истина);
#КонецЕсли
	
	ПараметрыФормы = Новый Структура();
	ОткрытьФорму("РегистрСведений.ОперацииПроверкиКМ.ФормаСписка", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);
	// -- НеМобильноеПриложение
	
	
КонецПроцедуры

// Возвращает идентификатор события проверки кода маркировки, используется в процедуре обработка оповещения формы
//
// Возвращаемое значение:
//   Строка - идентификатор события проверки кода маркировки
//
Функция СобытиеПроверкаКМ() Экспорт
	
	Возврат "ПодключаемоеОборудование.ПроверкаКодаМаркировки";
	
КонецФункции

// Возвращает типы операций проверки кода маркировки, используется в процедуре обработка оповещения формы
//
// Возвращаемое значение:
//   Структура - типы операций проверки кода маркировки:
//     * ЗапросККТ - Строка - выполняется запрос к локальной ККТ
//     * ЗапросККТЗавершено - Строка - завершен запрос к локальной ККТ
//     * ЗапросОИСМ - Строка - выполняется запрос к удаленному серверу ОИСМ
//     * ЗапросОИСМЗавершено - Строка - завершен запрос к удаленному серверу ОИСМ
//     * ПодтверждениеККТ - Строка - выполняется подтверждение продажи на локальной ККТ
//     * ПодтверждениеККТЗавершено - Строка - завершен подтверждение продажи на локальной ККТ
//
Функция СписокОперацийПроверкиКМ() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ЗапросККТ", "ЗапросККТ");
	Результат.Вставить("ЗапросККТЗавершено", "ЗапросККТЗавершено");
	Результат.Вставить("ЗапросОИСМ", "ЗапросОИСМ");
	Результат.Вставить("ЗапросОИСМЗавершено", "ЗапросОИСМЗавершено");
	Результат.Вставить("ПодтверждениеККТ", "ПодтверждениеККТ");
	Результат.Вставить("ПодтверждениеККТЗавершено", "ПодтверждениеККТЗавершено");
	Возврат Результат;
	
КонецФункции

// Возвращает типы операций проверки кода маркировки, используется в процедуре обработка оповещения формы
//
// Возвращаемое значение:
//   Структура - типы операций проверки кода маркировки:
//     * КодМаркировки - Строка - код маркировки в виде base64
//     * Операция - Строка - одно из значений структуры СписокОперацийПроверкиКМ();
//     * ДополнительныеПараметры - Неопределено, Структура - структура дополнительных параметров переданная при подготовке параметров запроса проверки КМ
//
Функция НовыйПараметрыОповещенияОбОперации() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("КодМаркировки", "");
	Результат.Вставить("Операция", "ЗапросОИСМ");
	Результат.Вставить("ДополнительныеПараметры", Неопределено);
	Возврат Результат;
	
КонецФункции

// Возвращает текущее состояние проверки кода маркировки
// 
// Возвращаемое значение:
//  Структура
Функция СостояниеПроверкиКМ() Экспорт
	
	Результат = Новый Структура();
	Результат.Вставить("ОбработкаЗавершена", Истина);
	Результат.Вставить("ВсегоОпераций", 0);
	Результат.Вставить("ВыполненоОпераций", 0);
	Результат.Вставить("Состояние", "");
	КонтекстОперации = Неопределено;
	ВосстановитьКонтекстОперации(КонтекстОперации);
	Если КонтекстОперации <> Неопределено Тогда
		ВыполненоОпераций = КонтекстОперации.РезультатПакета.РезультатыОпераций.Количество();
		ОсталосьОпераций  = КонтекстОперации.МассивОпераций.Количество();
		Если КонтекстОперации.Операции.Количество()>0 Тогда
			Состояние = КонтекстОперации.Операции[0];
		Иначе
			Состояние = "";
		КонецЕсли;
		Результат.ОбработкаЗавершена = КонтекстОперации.ОбработкаЗавершена;
		Результат.ВсегоОпераций = ВыполненоОпераций + ОсталосьОпераций;
		Результат.ВыполненоОпераций = ВыполненоОпераций;
		Результат.Состояние = Состояние;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Процедура НачатьПроверкуКМ(Оповещение, ПараметрыПодключения, ДанныеОперации) Экспорт
	
	КонтекстОперации = НовыйКонтекстОперации();
	ПодготовитьКонтекстОперации(КонтекстОперации, Оповещение, ДанныеОперации, ПараметрыПодключения);
	
	СписокДлительныхОпераций = МенеджерОборудованияКлиент.ПодключаемоеОборудование().ДлительныеОперации;
	СписокДлительныхОпераций.Вставить("ПроверкаКМ", КонтекстОперации);
	
	СледующийЭлементВПакете(КонтекстОперации);
	
КонецПроцедуры

Процедура ВалидацияКМ(КонтекстОперации) Экспорт
	
	ПараметрыОперации = КонтекстОперации.ПараметрыОперации;
	ТекущийРезультат = КонтекстОперации.ТекущийРезультат;
	Операции         = КонтекстОперации.Операции;
	
	Если ПустаяСтрока(ПараметрыОперации.КонтрольнаяМарка) Тогда
		ТекстОшибки = НСтр("ru = 'Контрольная марка не может быть пустой.';
							|en = 'Control mark cannot be blank.'");
		ТекущийРезультат.Результат = Ложь;
		ТекущийРезультат.Валидация = Ложь;
		ТекущийРезультат.ОписаниеОшибки = ТекстОшибки;
		Операции.Очистить();
		СледующаяОперация(КонтекстОперации);
		Возврат;
	КонецЕсли;
	
	РазобранныйКодМаркировки = МенеджерОборудованияМаркировкаКлиентСервер.РазобратьШтриховойКодТовара(ПараметрыОперации.КонтрольнаяМарка, Истина);
	Если РазобранныйКодМаркировки.Разобран Тогда
		ТекущийРезультат.Валидация = Истина;
		Операции.Удалить(0);
	Иначе
		ТекущийРезультат.Валидация = Ложь;
		ТекущийРезультат.ОписаниеОшибки = РазобранныйКодМаркировки.ОписаниеОшибки;
		Операции.Очистить();
	КонецЕсли;
	СледующаяОперация(КонтекстОперации);
	
КонецПроцедуры

Процедура ЗапросРазрешения(КонтекстОперации) Экспорт
	
	ПараметрыОперации = КонтекстОперации.ПараметрыОперации;
	ТекущийРезультат = КонтекстОперации.ТекущийРезультат;
	Операции = КонтекстОперации.Операции;
	
	Если ПараметрыОперации.ЗапросРазрешенияПродажиКМ Тогда
		// Запрос разрешения продажи
		РезультатРазрешения = ПродажаРазрешена(ПараметрыОперации.КонтрольнаяМарка);
		ТекущийРезультат.ПродажаРазрешена = РезультатРазрешения.ПродажаРазрешена;
		ТекущийРезультат.ДанныеРазрешенияПродажи = РезультатРазрешения.ДанныеРазрешенияПродажи;
		Если РезультатРазрешения.ПродажаРазрешена Тогда
			Операции.Удалить(0);
		Иначе
			ТекущийРезультат.Результат = Ложь;
			ТекущийРезультат.ОписаниеОшибки = НСтр("ru = 'Запрещена продажа';
													|en = 'Sale is prohibited'");
			Операции.Очистить();
		КонецЕсли;
	Иначе
		ТекущийРезультат.ПродажаРазрешена = Истина;
		Операции.Удалить(0);
	КонецЕсли;
	СледующаяОперация(КонтекстОперации);
	
КонецПроцедуры

Асинх Процедура ЗапросКМ(КонтекстОперации) Экспорт
	
	ПараметрыПодключения = КонтекстОперации.ПараметрыПодключения;
	ПараметрыОперации     = КонтекстОперации.ПараметрыОперации;
	ТекущийРезультат     = КонтекстОперации.ТекущийРезультат;
	Операции  = КонтекстОперации.Операции;
	
	ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
	ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
	ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ЗапросККТ;
	ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
	Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
	
	Команда = "RequestKM";
	Ответ = Ждать ПараметрыПодключения.ОбработчикДрайвера.ВыполнениеКоманды(ПараметрыПодключения, Команда, ПараметрыОперации);
	ЗаполнитьЗначенияСвойств(ТекущийРезультат, Ответ);
	Если Ответ.Свойство("ИдентификаторСессии") Тогда
		КонтекстОперации.РезультатПакета.ИдентификаторСессии = Ответ.ИдентификаторСессии;
	КонецЕсли;
	
	ИнтервалДоСледующейОперации = 0.1;
	Если Ответ.Результат Тогда
		ТекущийРезультат.Служебная.ЛокальныйОтветXML = Ответ.РезультатXML;
		ЛокальныйОтвет = ОбщегоНазначенияБПОКлиент.ПрочитатьКорневойЭлементXML(ТекущийРезультат.Служебная.ЛокальныйОтветXML);
		Если ЛокальныйОтвет.Свойство("Checking") И ВРег(ЛокальныйОтвет.Checking) = "TRUE"
			И ЛокальныйОтвет.Свойство("CheckingResult") И ВРег(ЛокальныйОтвет.CheckingResult) = "TRUE" Тогда
			КонтекстОперации.ЛокальнаяПроверкаУспешна = Истина;
		КонецЕсли;
		Операции.Удалить(0);
	Иначе
		ТекущийРезультат.Результат = Ложь;
		ИнтервалДоСледующейОперации = 0.1;
		Операции.Очистить();
	КонецЕсли;
	
	ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
	ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
	ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ЗапросККТЗавершено;
	ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
	Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
	
	СледующаяОперация(КонтекстОперации, ИнтервалДоСледующейОперации);
	
КонецПроцедуры

Асинх Процедура ПроверкаКМ(КонтекстОперации) Экспорт
	
	ПараметрыПодключения = КонтекстОперации.ПараметрыПодключения;
	ПараметрыОперации     = КонтекстОперации.ПараметрыОперации;
	ТекущийРезультат     = КонтекстОперации.ТекущийРезультат;
	Операции             = КонтекстОперации.Операции;
	СтатусРезультата     = КонтекстОперации.СтатусРезультата;
	
	Если Не ПараметрыОперации.ОтправлятьНаСерверОИСМ Тогда
		// Нет необходимости выполнять запрос статуса, т.к. запрос на удаленный сервере не выполнялся.
		Операции.Удалить(0);
		КонтекстОперации.ВыполняетсяУдаленнаяПроверкаКМ = Ложь;
		СледующаяОперация(КонтекстОперации);
		Возврат;
	КонецЕсли;
	
	Если Не КонтекстОперации.ВыполняетсяУдаленнаяПроверкаКМ Тогда
		
		ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
		ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
		ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ЗапросОИСМ;
		ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
		Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
		
		КонтекстОперации.ВыполняетсяУдаленнаяПроверкаКМ = Истина;
	КонецЕсли;
	
	ДанныеОперацииПолученияРезультата = Новый Структура();
	Команда = "GetProcessingKMResult";
	Ответ = Ждать ПараметрыПодключения.ОбработчикДрайвера.ВыполнениеКоманды(ПараметрыПодключения, Команда, ДанныеОперацииПолученияРезультата);
	Если Не Ответ.Результат Тогда
		// ошибка выполнения операции
		Операции.Очистить();
		КонтекстОперации.ВыполняетсяУдаленнаяПроверкаКМ = Ложь;
		
		ЗаполнитьЗначенияСвойств(ТекущийРезультат, Ответ);
		ТекущийРезультат.Служебная.УдаленныйОтветXML = ДанныеОперацииПолученияРезультата.РезультатXML;
		
		ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
		ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
		ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ЗапросОИСМЗавершено;
		ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
		Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
		
		СледующаяОперация(КонтекстОперации);
		Возврат;
	КонецЕсли;

	Если ДанныеОперацииПолученияРезультата.СтатусРезультатаКод = СтатусРезультата.РезультатЕщеНеПолучен Тогда
		// результат не получен, ждем небольшое время и пробуем снова
		СледующаяОперация(КонтекстОперации, 1);
		Возврат;
	КонецЕсли;
	
	ТекущийРезультат.Служебная.УдаленныйОтветXML = ДанныеОперацииПолученияРезультата.РезультатXML;
	
	Если ДанныеОперацииПолученияРезультата.СтатусРезультатаКод = СтатусРезультата.РезультатПолучен Тогда
		
		ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
		ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
		ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ЗапросОИСМЗавершено;
		ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
		Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
		
		УдаленныйОтвет = ОбщегоНазначенияБПОКлиент.ПрочитатьКорневойЭлементXML(ТекущийРезультат.Служебная.УдаленныйОтветXML);
		КонтекстОперации.УдаленнаяПроверкаУспешна = УдаленныйОтвет.Свойство("Result") И ВРег(УдаленныйОтвет.Result)="TRUE";
	КонецЕсли;
	
	Операции.Удалить(0);
	КонтекстОперации.ВыполняетсяУдаленнаяПроверкаКМ = Ложь;
	СледующаяОперация(КонтекстОперации);
	
КонецПроцедуры

Асинх Процедура ПодтверждениеКМ(КонтекстОперации) Экспорт
	
	ПараметрыПодключения = КонтекстОперации.ПараметрыПодключения;
	ПараметрыПакета      = КонтекстОперации.ПараметрыПакета;
	ПараметрыОперации     = КонтекстОперации.ПараметрыОперации;
	ТекущийРезультат     = КонтекстОперации.ТекущийРезультат;
	Операции  = КонтекстОперации.Операции;
	
	ОжидатьПолучениеОтветаОИСМ = ПараметрыОперации.ОжидатьПолучениеОтветаОИСМ;
	
	ВыполнятьПодтверждение = Ложь;
	Если КонтекстОперации.ЛокальнаяПроверкаУспешна Тогда
		Если Не ОжидатьПолучениеОтветаОИСМ Тогда 
			ВыполнятьПодтверждение = Истина;
		Иначе
			Если КонтекстОперации.УдаленнаяПроверкаУспешна Тогда
				ВыполнятьПодтверждение = Истина;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;
	Если ПараметрыОперации.ИгнорироватьРезультатПроверкиКМ Тогда
		ВыполнятьПодтверждение = Истина;
	КонецЕсли;
	
	Если ВыполнятьПодтверждение Тогда
		
		ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
		ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
		ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ПодтверждениеККТ;
		ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
		Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
		
		Команда = "ConfirmKM";
		ПараметрыОперации.Выбытие = Истина;
		Ответ = Ждать ПараметрыПодключения.ОбработчикДрайвера.ВыполнениеКоманды(ПараметрыПодключения, Команда, ПараметрыОперации);
		ЗаполнитьЗначенияСвойств(ТекущийРезультат, Ответ);
		ТекущийРезультат.ПодтверждениеВыполнено = Истина;
		ТекущийРезультат.Служебная.ПокупкаПодтверждена = ПараметрыОперации.Выбытие;
		
		ПараметрыОповещения = НовыйПараметрыОповещенияОбОперации();
		ПараметрыОповещения.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
		ПараметрыОповещения.Операция = СписокОперацийПроверкиКМ().ПодтверждениеККТЗавершено;
		ПараметрыОповещения.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
		Оповестить(СобытиеПроверкаКМ(), ПараметрыОповещения, КонтекстОперации.ПараметрыПакета.ИдентификаторКлиента);
		
	КонецЕсли;
	
	Операции.Удалить(0);
	СледующаяОперация(КонтекстОперации);
	
КонецПроцедуры

Процедура ВосстановитьКонтекстОперации(КонтекстОперации) Экспорт
	
	СписокДлительныхОпераций = МенеджерОборудованияКлиент.ПодключаемоеОборудование().ДлительныеОперации;
	КонтекстОперации = СписокДлительныхОпераций.Получить("ПроверкаКМ");
	
КонецПроцедуры

Процедура ДлительнаяОперацияПроверкаКМ(ОповещениеПриЗавершении, Команда, ПараметрыПодключения, ДанныеОперации) Экспорт
	
	Если ДанныеОперации.ОтображатьФорму Тогда
		Параметры = Новый Структура();
		Параметры.Вставить("ПараметрыПодключения", ПараметрыПодключения);
		Параметры.Вставить("ДанныеОперации", ДанныеОперации);
		Параметры.Вставить("ОповещениеПриЗавершении", ОповещениеПриЗавершении);
		ОбщегоНазначенияБПОКлиент.УстановитьПараметрПриложения("БПО.ПроверкаКМ", Параметры);
		ПараметрыФормы = Новый Структура();
		ПараметрыФормы.Вставить("Команда", Команда);
		ПараметрыФормы.Вставить("ДанныеОперации", ДанныеОперации);
		ОткрытьФорму("ОбщаяФорма.ПроверкаКонтрольнойМаркиБПО",ПараметрыФормы,,,,, ОповещениеПриЗавершении);
	Иначе
		НачатьПроверкуКМ(ОповещениеПриЗавершении, ПараметрыПодключения, ДанныеОперации);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйКонтекстОперации()
	
	КонтекстОперации = Новый Структура();
	КонтекстОперации.Вставить("Операции", Новый Массив());
	КонтекстОперации.Вставить("ОбработкаЗавершена", Ложь);
	КонтекстОперации.Вставить("МассивОпераций", Неопределено);
	КонтекстОперации.Вставить("ПараметрыОперации", Неопределено);
	КонтекстОперации.Вставить("ТекущийРезультат", Неопределено);
	КонтекстОперации.Вставить("ПараметрыПакета", Неопределено);
	КонтекстОперации.Вставить("ПараметрыПодключения", Неопределено);
	КонтекстОперации.Вставить("ОповещениеЗавершения", Неопределено);
	
	КонтекстОперации.Вставить("ВыполняетсяУдаленнаяПроверкаКМ", Ложь);
	КонтекстОперации.Вставить("ВалидацияУспешна", Истина);
	КонтекстОперации.Вставить("ПродажаРазрешена", Истина);
	КонтекстОперации.Вставить("ЛокальнаяПроверкаУспешна", Ложь);
	КонтекстОперации.Вставить("УдаленнаяПроверкаУспешна", Ложь);
	
	КонтекстОперации.Вставить("ИдентификаторКлиента", Истина);
	
	РезультатПакета = ПодключаемоеОборудованиеДрайверКлиент.РезультатОперацииНаОборудовании(Истина, "");
	РезультатПакета.Вставить("ИдентификаторСессии", Неопределено);
	РезультатПакета.Вставить("РезультатыОпераций", Новый Массив());
	КонтекстОперации.Вставить("РезультатПакета", РезультатПакета);
	
	СтатусРезультата = Новый Структура();
	СтатусРезультата.Вставить("РезультатПолучен", 0);
	СтатусРезультата.Вставить("РезультатЕщеНеПолучен", 1);
	СтатусРезультата.Вставить("РезультатНеМожетБытьПолучен", 2);
	КонтекстОперации.Вставить("СтатусРезультата", СтатусРезультата);
	
	СписокОпераций = СписокОперацийПроверкиКМ();
	СписокОпераций.Вставить("Валидация", "Валидация");
	СписокОпераций.Вставить("ЗапросРазрешения", "ЗапросРазрешения");
	КонтекстОперации.Вставить("СписокОпераций", СписокОпераций);
	
	Возврат КонтекстОперации;
	
КонецФункции

Функция НовыйРезультатОперации()
	
	РезультатОперации = ПодключаемоеОборудованиеДрайверКлиент.РезультатОперацииНаОборудовании(Истина, "");
	Служебная = Новый Структура();
	Служебная.Вставить("ЛокальныйОтветXML", Неопределено);
	Служебная.Вставить("УдаленныйОтветXML", Неопределено);
	Служебная.Вставить("ЗапросКМ", Неопределено);
	Служебная.Вставить("ПокупкаПодтверждена", Неопределено);
	РезультатОперации.Вставить("Служебная", Служебная);
	РезультатОперации.Вставить("КодМаркировки", "");
	РезультатОперации.Вставить("Валидация", Истина);
	РезультатОперации.Вставить("ПродажаРазрешена", Истина);
	РезультатОперации.Вставить("ИдентификаторЗапроса", Неопределено);
	РезультатОперации.Вставить("ДанныеРазрешенияПродажи", Неопределено);
	РезультатОперации.Вставить("ПроверкаКМ", Ложь);
	РезультатОперации.Вставить("ПодтверждениеВыполнено", Ложь);
	РезультатОперации.Вставить("ДополнительныеПараметры", Неопределено);
	// для обратной совместимости
	РезультатОперации.Вставить("КодМаркировкиПроверен", Ложь);
	РезультатОперации.Вставить("РезультатПроверки", Ложь);
	РезультатОперации.Вставить("РезультатПроверкиОИСМ", Ложь);
	РезультатОперации.Вставить("КодРезультатаПроверкиОИСМ", 0);
	РезультатОперации.Вставить("РезультатПроверкиОИСМПредставление", "00000000");
	РезультатОперации.Вставить("КодОбработкиЗапроса", Неопределено);
	
	Возврат РезультатОперации;
	
КонецФункции

Процедура ПодготовитьКонтекстОперации(КонтекстОперации, ОповещениеЗавершения, ПараметрыПакета, ПараметрыПодключения)
	
	Если ТипЗнч(ПараметрыПакета.ЗапросыКМ) = Тип("Массив") Тогда
		МассивОпераций = ПараметрыПакета.ЗапросыКМ;
	Иначе
		МассивОпераций = Новый Массив();
		МассивОпераций.Добавить(ПараметрыПакета.ЗапросыКМ);
	КонецЕсли;
	
	КонтекстОперации.ОповещениеЗавершения = ОповещениеЗавершения;
	КонтекстОперации.МассивОпераций       = МассивОпераций;
	КонтекстОперации.ПараметрыПакета      = ПараметрыПакета;
	КонтекстОперации.ПараметрыПодключения = ПараметрыПодключения;
	КонтекстОперации.ИдентификаторКлиента = ПараметрыПакета.ИдентификаторКлиента;
	
КонецПроцедуры

Процедура СледующийЭлементВПакете(КонтекстОперации)
	
	МассивОпераций = КонтекстОперации.МассивОпераций;
	Если МассивОпераций.Количество() = 0 Тогда
		// Завершить пакет операций
		Возврат;
	КонецЕсли;
	
	ПараметрыПакета = КонтекстОперации.ПараметрыПакета;
	ПараметрыОперации = ОбщегоНазначенияБПОКлиент.СкопироватьРекурсивно(МассивОпераций[0]);
	ПараметрыОперации.Вставить("Выбытие", Истина);
	
	ТекущийРезультат = НовыйРезультатОперации();;
	КонтекстОперации.ПараметрыОперации = ПараметрыОперации;
	КонтекстОперации.ТекущийРезультат = ТекущийРезультат;
	КонтекстОперации.Операции = ВыполняемыеОперации(КонтекстОперации);
	ТекущийРезультат.Служебная.ЗапросКМ = ПараметрыОперации;
	ТекущийРезультат.КодМаркировки = ПараметрыОперации.КонтрольнаяМарка;
	ТекущийРезультат.ДополнительныеПараметры = ПараметрыОперации.ДополнительныеПараметры;
	
	СледующаяОперация(КонтекстОперации);
	
КонецПроцедуры

Функция ВыполняемыеОперации(КонтекстОперации)
	
	ПараметрыПодключения = КонтекстОперации.ПараметрыПодключения;
	ПараметрыПакета      = КонтекстОперации.ПараметрыПакета;
	ПараметрыОперации     = КонтекстОперации.ПараметрыОперации;
	РевизияИнтерфейса    = ПараметрыПодключения.РевизияИнтерфейса;
	СписокОпераций       = КонтекстОперации.СписокОпераций;
	
	Операции = Новый Массив();
	Если ПараметрыОперации.ВыполнятьВалидацию Тогда
		Операции.Добавить(СписокОпераций.Валидация);
	КонецЕсли;
	Если ПараметрыОперации.ЗапросРазрешенияПродажиКМ Тогда
		Операции.Добавить(СписокОпераций.ЗапросРазрешения);
	КонецЕсли;
	Операции.Добавить(СписокОпераций.ЗапросККТ);
	Если РевизияИнтерфейса >= 4000 Тогда
		Если ПараметрыОперации.ЗапросПроверкиКМСредствамиККТ Тогда
			Операции.Добавить(СписокОпераций.ЗапросОИСМ);
			Операции.Добавить(СписокОпераций.ПодтверждениеККТ);
		КонецЕсли;
	Иначе
		Операции.Добавить(СписокОпераций.ЗапросОИСМ);
		Операции.Добавить(СписокОпераций.ПодтверждениеККТ);
	КонецЕсли;
	
	Возврат Операции;
	
КонецФункции

Функция ПродажаРазрешена(КодМаркировки)
	
	Результат = Новый Структура();
	Результат.Вставить("ПродажаРазрешена", Истина);
	Результат.Вставить("ДанныеРазрешенияПродажи", Неопределено);
	
	Возврат Результат;
	
КонецФункции

Процедура СледующаяОперация(КонтекстОперации, Интервал = 0.1)
	
	Операции       = КонтекстОперации.Операции;
	СписокОпераций = КонтекстОперации.СписокОпераций;
	Если Операции.Количество()=0 Тогда
		// завершить операцию
		ЗавершитьВыполнениеОперации(КонтекстОперации);
		Возврат;
	КонецЕсли;
	Операция = КонтекстОперации.Операции[0];
	Если Операция = СписокОпераций.Валидация Тогда
		ВалидацияКМ(КонтекстОперации);
	ИначеЕсли Операция = СписокОпераций.ЗапросРазрешения Тогда
		ЗапросРазрешения(КонтекстОперации);
	ИначеЕсли Операция = СписокОпераций.ЗапросККТ Тогда
		ЗапросКМ(КонтекстОперации);
	ИначеЕсли Операция = СписокОпераций.ПодтверждениеККТ Тогда
		ПодтверждениеКМ(КонтекстОперации);
	Иначе
		ПодключитьОбработчикОжидания("ПодключаемоеОборудование_ПроверкаКМ", Интервал, Истина);
	КонецЕсли;
	
КонецПроцедуры

Процедура ЗавершитьВыполнениеОперации(КонтекстОперации)
	
	ПараметрыОперации = КонтекстОперации.ПараметрыОперации;
	ТекущийРезультат = КонтекстОперации.ТекущийРезультат;
	РезультатПакета  = КонтекстОперации.РезультатПакета;
	МассивОпераций   = КонтекстОперации.МассивОпераций;
	РезультатПакета.РезультатыОпераций.Добавить(ТекущийРезультат);
	РезультатПакета.Результат = РезультатПакета.Результат И ТекущийРезультат.Результат;
	РезультатПакета.ОписаниеОшибки = СокрЛП(РезультатПакета.ОписаниеОшибки + Символы.ПС + ТекущийРезультат.ОписаниеОшибки);
	
	ТекущийРезультат.ПроверкаКМ = КонтекстОперации.ЛокальнаяПроверкаУспешна И КонтекстОперации.УдаленнаяПроверкаУспешна;
	
	МассивОпераций.Удалить(0);
	Если МассивОпераций.Количество()=0 Тогда
		ЗавершитьВыполнениеВсехОпераций(КонтекстОперации);
		Возврат;
	КонецЕсли;
	СледующийЭлементВПакете(КонтекстОперации);
	
КонецПроцедуры

Процедура ЗавершитьВыполнениеВсехОпераций(КонтекстОперации)
	
	КонтекстОперации.ОбработкаЗавершена = Истина;
	РезультатПакета = КонтекстОперации.РезультатПакета;
	
	СписокДлительныхОпераций = МенеджерОборудованияКлиент.ПодключаемоеОборудование().ДлительныеОперации;
	СписокДлительныхОпераций.Удалить("ПроверкаКМ");
	
	Оповещение = КонтекстОперации.ОповещениеЗавершения;
	Если Оповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(Оповещение, РезультатПакета);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти