
#Область СлужебныйПрограммныйИнтерфейс

// Проверяет необходимость обработки данных связанной с изменениями свойств организации.
// 
// Параметры:
//	СостояниеОрганизации - структура с данными организации.
//		Ссылка
//		ПрименятьРайонныйКоэффициент
//		ПрименятьСевернуюНадбавку.
//	ВозвращаемаяИнформация - структура с полями
//		ОбработатьСН
//		ОбработатьРК.
//	
// Информация возвращается в переданном параметре ВозвращаемаяИнформация.
// Если ВозвращаемаяИнформация.ОбработатьСН = Истина, то требуется обработка 
// данных по северным надбавкам (СН).
// Если ВозвращаемаяИнформация.ОбработатьРК = Истина, то требуется обработка 
// данных по районным коэффициентам (РК).
Процедура НеобходимостьОбработкиДанныхПриЗаписиОрганизации(СостояниеОрганизации, ВозвращаемаяИнформация) Экспорт
	ВозвращаемаяИнформация = Новый Структура("ОбработатьСН,ОбработатьРК,ПрименятьСевернуюНадбавку,ПрименятьРайонныйКоэффициент", Ложь, Ложь);
	Если НЕ СостояниеОрганизации.ПрименятьСевернуюНадбавку ИЛИ НЕ СостояниеОрганизации.ПрименятьРайонныйКоэффициент Тогда
		
		МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		
		ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
		ПараметрыПолученияСотрудниковОрганизаций.Организация = СостояниеОрганизации.Ссылка;
		
		КадровыйУчет.СоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудниковОрганизаций);
		
		Запрос = Новый Запрос;
		Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
		Запрос.Текст  = 
		"ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА 1 В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					1
		|				ИЗ
		|					ВТСотрудникиОрганизации КАК ОтобранныеСотрудники ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
		|						ПО
		|							Сотрудники.Ссылка = ОтобранныеСотрудники.Сотрудник
		|				ГДЕ
		|					Сотрудники.ТекущийПроцентСевернойНадбавки > 0
		|					И НЕ &ПрименятьСевернуюНадбавку)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОбработатьСН,
		|	ВЫБОР
		|		КОГДА 1 В
		|				(ВЫБРАТЬ ПЕРВЫЕ 1
		|					1
		|				ИЗ
		|					Справочник.ПодразделенияОрганизаций КАК Подразделения
		|				ГДЕ
		|					Подразделения.Владелец = Организации.Ссылка
		|					И Подразделения.РайонныйКоэффициент <> 1
		|					И НЕ &ПрименятьРайонныйКоэффициент)
		|			ТОГДА ИСТИНА
		|		ИНАЧЕ ЛОЖЬ
		|	КОНЕЦ КАК ОбработатьРК
		|ИЗ
		|	Справочник.Организации КАК Организации
		|ГДЕ
		|	Организации.Ссылка = &Ссылка
		|	И (Организации.ПрименятьСевернуюНадбавку <> &ПрименятьСевернуюНадбавку
		|			ИЛИ Организации.ПрименятьРайонныйКоэффициент <> &ПрименятьРайонныйКоэффициент)";
		Запрос.УстановитьПараметр("Ссылка", СостояниеОрганизации.Ссылка);
		Запрос.УстановитьПараметр("ПрименятьСевернуюНадбавку", СостояниеОрганизации.ПрименятьСевернуюНадбавку);
		Запрос.УстановитьПараметр("ПрименятьРайонныйКоэффициент", СостояниеОрганизации.ПрименятьРайонныйКоэффициент);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ВозвращаемаяИнформация, Выборка);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

// Выполняет обработку данных при записи организации.
// Список обработок передается как массив строковых идентификаторов параметром СписокОбработок.
// Параметры:
//	Организация - ссылка на организацию.
//	СписокОбработок - список обработок.
//		Поддерживаются обработки:
//			УдалитьСН - удаление данных о северных надбавках.
//			УдалитьРК - удаление данных о районных коэффициентах.
Процедура ОбработкаДанныхПриЗаписиОрганизации(Организация, СписокОбработок) Экспорт
	Для Каждого ИмяОбработки Из СписокОбработок Цикл
		НачатьТранзакцию();
		Если ИмяОбработки = "УдалитьСН" Тогда
			УдалитьСНПоОрганизации(Организация);
		ИначеЕсли ИмяОбработки = "УдалитьРК" Тогда
			УдалитьРКПоОрганизации(Организация);
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	КонецЦикла;
	
КонецПроцедуры

Функция ПроверитьАдрес(Знач Адрес, Знач ВидАдреса = Неопределено) Экспорт
	
	Возврат РаботаСАдресами.ПроверитьАдрес(Адрес, ВидАдреса);
	
КонецФункции

Функция ДанныеРегистрацииВНалоговомОргане(СтруктурнаяЕдиница, РегистрацияВНалоговомОргане) Экспорт
	
	ДанныеРегистрации = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(РегистрацияВНалоговомОргане, "Код,Наименование,КПП,КодПоОКАТО,КодПоОКТМО");
	
	Если РегистрацияВНалоговомОргане.Владелец.Метаданные().Реквизиты.Найти("ЮридическоеФизическоеЛицо") <> Неопределено Тогда
		РеквизитЮридическоеФизическоеЛицо = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(РегистрацияВНалоговомОргане.Владелец, "ЮридическоеФизическоеЛицо");
		ЭтоФизическоеЛицо = РеквизитЮридическоеФизическоеЛицо = Перечисления.ЮридическоеФизическоеЛицо.ФизическоеЛицо;
	Иначе
		ЭтоФизическоеЛицо = Ложь;
	КонецЕсли;
	
	ДанныеРегистрации.Вставить("ВладелецФизическоеЛицо", ЭтоФизическоеЛицо);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсторияРегистрацийВНалоговомОргане.Период КАК Период
		|ИЗ
		|	РегистрСведений.ИсторияРегистрацийВНалоговомОргане КАК ИсторияРегистрацийВНалоговомОргане
		|ГДЕ
		|	ИсторияРегистрацийВНалоговомОргане.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
		|	И ИсторияРегистрацийВНалоговомОргане.РегистрацияВНалоговомОргане = &РегистрацияВНалоговомОргане
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ";
		
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("РегистрацияВНалоговомОргане", РегистрацияВНалоговомОргане);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДанныеРегистрации.Вставить("Период", Выборка.Период);
	Иначе
		ДанныеРегистрации.Вставить("Период", Неопределено);
	КонецЕсли;
	
	Возврат ДанныеРегистрации;
	
КонецФункции

Функция ДанныеСамостоятельнойКлассификационнойЕдиницы(СтруктурнаяЕдиница, СамостоятельнаяКлассификационнаяЕдиница) Экспорт
	
	ДанныеСКЕ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(СамостоятельнаяКлассификационнаяЕдиница, "Наименование,КодОКВЭД2,КлассПрофессиональногоРиска");
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ИсторияСамостоятельныхКлассификационныхЕдиниц.Период КАК Период
		|ИЗ
		|	РегистрСведений.ИсторияСамостоятельныхКлассификационныхЕдиниц КАК ИсторияСамостоятельныхКлассификационныхЕдиниц
		|ГДЕ
		|	ИсторияСамостоятельныхКлассификационныхЕдиниц.СтруктурнаяЕдиница = &СтруктурнаяЕдиница
		|	И ИсторияСамостоятельныхКлассификационныхЕдиниц.СКЕ = &СамостоятельнаяКлассификационнаяЕдиница
		|
		|УПОРЯДОЧИТЬ ПО
		|	Период УБЫВ";
		
	Запрос.УстановитьПараметр("СтруктурнаяЕдиница", СтруктурнаяЕдиница);
	Запрос.УстановитьПараметр("СамостоятельнаяКлассификационнаяЕдиница", СамостоятельнаяКлассификационнаяЕдиница);
	
	Выборка = Запрос.Выполнить().Выбрать();
	ПериодСКЕ = Неопределено;
	Если Выборка.Следующий() Тогда
		ПериодСКЕ = Выборка.Период;
	КонецЕсли;
	ДанныеСКЕ.Вставить("Период", ПериодСКЕ);
	Запрос = Новый Запрос;
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевСрезПоследних.Ставка КАК Ставка
	               |ИЗ
	               |	РегистрСведений.СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаев.СрезПоследних(&Период, Организация = &СКЕ) КАК СтавкаВзносаНаСтрахованиеОтНесчастныхСлучаевСрезПоследних";
	
	Запрос.УстановитьПараметр("Период", ПериодСКЕ);
	Запрос.УстановитьПараметр("СКЕ", СамостоятельнаяКлассификационнаяЕдиница);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ДанныеСКЕ.Вставить("Ставка", Выборка.Ставка);
	Иначе
		ДанныеСКЕ.Вставить("Ставка", Неопределено);
	КонецЕсли;
	
	Возврат ДанныеСКЕ;

КонецФункции

// Возвращает данные присоединенного к объекту файла.
//
// Параметры:	
//  ВладелецФайла      - ОпределяемыйТип.ВладелецПрисоединенныхФайлов - Ссылка на объект-владелец файлов.
//  ИдентификаторФормы - УникальныйИдентификатор - см. РаботаСФайлами.ПолучитьДанныеФайла
//                                                 По умолчанию не задан.
//  ПолучатьСсылкуНаДвоичныеДанные - Булево      - см. РаботаСФайлами.ПолучитьДанныеФайла 
//                                                 По умолчанию - Истина.
//
// Возвращаемое значение:
//  Структура - см. РаботаСФайлами.ПолучитьДанныеФайла.
//		
Функция ПолучитьДанныеФайла(ВладелецФайла, ИдентификаторФормы = Неопределено, ПолучатьСсылкуНаДвоичныеДанные = Истина) Экспорт
	Возврат ЗарплатаКадры.ПолучитьДанныеФайла(ВладелецФайла, ИдентификаторФормы, ПолучатьСсылкуНаДвоичныеДанные, Ложь);	
КонецФункции

// Возвращает ссылку на валюту в которой происходит расчет заработной платы (рубль РФ).
// Номинирование тарифов, надбавок, выплата зарплаты допускается в любой валюте, 
// но расчеты выполняются в валюте учета зарплаты.
Функция ВалютаУчетаЗаработнойПлаты() Экспорт
	Возврат ЗарплатаКадры.ВалютаУчетаЗаработнойПлаты();
КонецФункции

Функция СвойстваОтветственногоЛица(Пользователь) Экспорт
	
	СвойстваОтветственного = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Пользователь, "Ссылка,ПометкаУдаления,Недействителен,Служебный");
	Возврат СвойстваОтветственного;
	
КонецФункции

Функция ЭтоПолноправныйПользователь() Экспорт
	Возврат Пользователи.ЭтоПолноправныйПользователь();
КонецФункции

Процедура УстановитьЗначениеКонстанты(ИмяКонстанты, ЗначениеКонстанты) Экспорт
	
	НачатьТранзакцию();
	Попытка
		КонстантаМенеджер = Константы[ИмяКонстанты];
		ТекущееЗначение  = КонстантаМенеджер.Получить();
		Если ТекущееЗначение <> ЗначениеКонстанты Тогда
			КонстантаМенеджер.Установить(ЗначениеКонстанты);
		КонецЕсли;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВосстановитьНачальныеЗначения(Знач ИменаОбъектовМетаданных, Знач ИдентификаторФормы) Экспорт
	ИмяПроцедуры = "ЗарплатаКадры.УстановитьНачальныеЗначения";
	
	ПараметрыПроцедуры = Новый Структура;
	ПараметрыПроцедуры.Вставить("ИменаОбъектовМетаданных", ИменаОбъектовМетаданных);
	
	ПараметрыЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(ИдентификаторФормы);
	ПараметрыЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Установка начальных значений';
														|en = 'Set initial values'");
	ПараметрыЗапуска.ОжидатьЗавершение = 0;
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяПроцедуры, ПараметрыПроцедуры, ПараметрыЗапуска);
КонецФункции

Процедура УдалитьСНПоОрганизации(Организация)
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация = Организация;
	
	КадровыйУчет.СоздатьВТСотрудникиОрганизации(МенеджерВременныхТаблиц, Истина, ПараметрыПолученияСотрудниковОрганизаций);
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Сотрудники.Ссылка,
	|	Сотрудники.Наименование
	|ИЗ
	|	ВТСотрудникиОрганизации КАК ОтобранныеСотрудники
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК Сотрудники
	|		ПО (Сотрудники.Ссылка = ОтобранныеСотрудники.Сотрудник)
	|ГДЕ
	|	Сотрудники.ТекущийПроцентСевернойНадбавки > 0";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.ТекущийПроцентСевернойНадбавки = 0;
		Попытка
			Объект.Заблокировать();
			Объект.Записать();
		Исключение
			ТекстИсключения = СтрШаблон(
				НСтр("ru = 'Ошибка при записи сотрудника %1. Возможно, данные сотрудника редактируются другим пользователем';
					|en = 'Cannot record employee %1. Another user might be editing the employee''s data.'"), 
				Выборка.Наименование);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
	КонецЦикла;
	
КонецПроцедуры

Процедура УдалитьРКПоОрганизации(Организация)
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Подразделения.Ссылка,
	|	Подразделения.Наименование
	|ИЗ
	|	Справочник.ПодразделенияОрганизаций КАК Подразделения
	|ГДЕ
	|	Подразделения.Владелец = &Организация
	|	И Подразделения.РайонныйКоэффициент <> 1";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Объект = Выборка.Ссылка.ПолучитьОбъект();
		Объект.РайонныйКоэффициент = 1;
		Объект.ДополнительныеСвойства.Вставить("ОбработкаЗаписиРодителя", Истина);
		Попытка
			Объект.Заблокировать();
		Исключение
			ТекстИсключения = СтрШаблон(
				НСтр("ru = 'Ошибка при записи подразделения %1. Возможно, данные подразделения редактируются другим пользователем';
					|en = 'An error occurred while writing the %1 business unit. Maybe, the business unit data is being edited by another user '"), 
				Выборка.Наименование);
			ВызватьИсключение ТекстИсключения;
		КонецПопытки;
		Объект.Записать();
	КонецЦикла;
	
КонецПроцедуры

// Возвращает значения заполнения, передаваемые при создании нового документа из формы списка журнала
// см. описание ЗарплатаКадры.ДинамическийСписокПередНачаломДобавления.
//
Процедура ДинамическийСписокПередНачаломДобавления(ПараметрыОткрытия, ФизическоеЛицо, ОрганизацияОтбора, ТипДокумента, ИмяПоляСотрудник = "Сотрудник", ИмяПоляФизическоеЛицо = "ФизическоеЛицо") Экспорт
	ЗарплатаКадры.ДинамическийСписокПередНачаломДобавления(ПараметрыОткрытия, ФизическоеЛицо, ОрганизацияОтбора, ТипДокумента, ИмяПоляСотрудник, ИмяПоляФизическоеЛицо);
КонецПроцедуры

Функция СБазойРаботаетЕдинственныйПользователь() Экспорт
	
	СБазойРаботаетЕдинственныйПользователь = Истина;
	
	УстановитьПривилегированныйРежим(Истина);
	
	НомерТекущегоСеанса = НомерСеансаИнформационнойБазы();
	СеансыИнформационнойБазы = ПолучитьСеансыИнформационнойБазы();
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		
		Для Каждого Сеанс Из СеансыИнформационнойБазы Цикл
			
			Если Сеанс.НомерСеанса <> НомерТекущегоСеанса
				И (Сеанс.ИмяПриложения = "1CV8"
					Или Сеанс.ИмяПриложения = "1CV8C"
					Или Сеанс.ИмяПриложения = "WebClient") Тогда
				
				СБазойРаботаетЕдинственныйПользователь = Ложь;
				Прервать;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Ложь);
	
	Возврат СБазойРаботаетЕдинственныйПользователь;
	
КонецФункции

Функция ДанныеАвтоподбораЗначенияСтроковогоРеквизита(Текст, ВидСтроки) Экспорт 
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Текст", Текст + "%");
	Запрос.УстановитьПараметр("ВидСтроки", ВидСтроки);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗначенияСтроковыхРеквизитов.ЗначениеСтроки КАК ЗначениеСтроки
	               |ИЗ
	               |	РегистрСведений.ЗначенияСтроковыхРеквизитов КАК ЗначенияСтроковыхРеквизитов
	               |ГДЕ
	               |	ЗначенияСтроковыхРеквизитов.ВидСтроки = &ВидСтроки
	               |	И ЗначенияСтроковыхРеквизитов.ЗначениеСтроки ПОДОБНО &Текст";
	
	ДанныеВыбора = Новый СписокЗначений;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ДанныеВыбора.Добавить(Выборка.ЗначениеСтроки);
	КонецЦикла;
	
	Возврат ДанныеВыбора;
	
КонецФункции

Функция УОрганизацииЕстьФилиалы(Знач Организация) Экспорт
	
	Возврат ЗарплатаКадрыПовтИсп.УОрганизацииЕстьФилиалы( Организация);
	
КонецФункции

Функция ДатаВступленияВСилуНА(ИмяНА) Экспорт
	Возврат ЗарплатаКадрыПовтИсп.ДатаВступленияВСилуНА(ИмяНА);
КонецФункции

Функция НачисленияРКСН() Экспорт
	
	Возврат ЗарплатаКадрыПовтИсп.НачисленияРКСН();
	
КонецФункции

#КонецОбласти
