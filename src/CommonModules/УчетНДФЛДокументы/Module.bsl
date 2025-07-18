
#Область СлужебныйПрограммныйИнтерфейс

// Проверяет заполнение кодов вычета НДФЛ документа.
// Параметры:
//		ДокументОбъект - объект проверяемого документа.
//		Отказ - устанавливается в Истина при непрохождении проверки.
Процедура ПроверитьЗаполненияКодовВычетаДокумента(ДокументОбъект, Отказ) Экспорт
	
	Если Не ВыполнятьПроверкуЗаполненияКодовВычета(ДокументОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	ЗарплатаКадры.СоздатьВТПоТаблицеЗначений(МенеджерВременныхТаблиц, ДокументОбъект.НДФЛ.Выгрузить(), "ВТДокументНДФЛ");
	ЗарплатаКадры.СоздатьВТПоТаблицеЗначений(МенеджерВременныхТаблиц, 
	ДокументОбъект.ПримененныеВычетыНаДетейИИмущественные.Выгрузить(), "ВТДокументПримененныеВычетыНаДетейИИмущественные");
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ДокументНДФЛ.ФизическоеЛицо,
		|	ДокументНДФЛ.ИдентификаторСтрокиНДФЛ,
		|	ДокументНДФЛ.НомерСтроки,
		|	""ПредставлениеВычетовНаДетейИИмущественных"" КАК ПолеВычета
		|ИЗ
		|	ВТДокументНДФЛ КАК ДокументНДФЛ
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ ВТДокументПримененныеВычетыНаДетейИИмущественные КАК ДокументПримененныеВычетыНаДетейИИмущественные
		|		ПО ДокументНДФЛ.ИдентификаторСтрокиНДФЛ = ДокументПримененныеВычетыНаДетейИИмущественные.ИдентификаторСтрокиНДФЛ
		|ГДЕ
		|	ДокументПримененныеВычетыНаДетейИИмущественные.КодВычета = &ПустойКодВычета
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ДокументНДФЛ.ФизическоеЛицо,
		|	ДокументНДФЛ.ИдентификаторСтрокиНДФЛ,
		|	ДокументНДФЛ.НомерСтроки,
		|	""ПредставлениеВычетовЛичных""
		|ИЗ
		|	ВТДокументНДФЛ КАК ДокументНДФЛ
		|ГДЕ
		|	(ДокументНДФЛ.ПримененныйВычетЛичный <> 0
		|				И ДокументНДФЛ.ПримененныйВычетЛичныйКодВычета = &ПустойКодВычета
		|			ИЛИ ДокументНДФЛ.ПримененныйВычетЛичныйКЗачетуВозврату <> 0
		|				И ДокументНДФЛ.ПримененныйВычетЛичныйКЗачетуВозвратуКодВычета = &ПустойКодВычета)";
		
	Запрос.УстановитьПараметр("ПустойКодВычета", Справочники.ВидыВычетовНДФЛ.ПустаяСсылка());
	Результат = Запрос.Выполнить();
	Если Результат.Пустой() Тогда
		Возврат;
	КонецЕсли;
	
	Выборка = Результат.Выбрать();
	МаксимальноСообщений = 10;
	ВыводимыхСообщений = 0;
	
	Пока Выборка.Следующий() Цикл
		
		Отказ = Истина;
		Если ВыводимыхСообщений < МаксимальноСообщений Тогда
			
			ОбщегоНазначения.СообщитьПользователю(
				СтрШаблон(
					НСтр("ru = 'В строке %1 сотрудника %2 обнаружены незаполненные коды вычетов НДФЛ';
						|en = 'Unpopulated PIT deduction codes are found in line %1 of the %2 employee'"),
					Выборка.НомерСтроки,
					Выборка.ФизическоеЛицо),,
				ОбщегоНазначенияКлиентСервер.ПутьКТабличнойЧасти("Объект.НДФЛ",  Выборка.НомерСтроки, Выборка.ПолеВычета),,
				Отказ);
			ВыводимыхСообщений = ВыводимыхСообщений + 1;
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры

Функция ЕстьПраваНаЧтениеДанныхУчетаНДФЛ() Экспорт
	
	Возврат ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.СведенияОДоходахНДФЛ)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ПредоставленныеСтандартныеИСоциальныеВычетыНДФЛ)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.ИмущественныеВычетыНДФЛ)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.РасчетыНалогоплательщиковСБюджетомПоНДФЛ)
		И ПравоДоступа("Чтение", Метаданные.РегистрыНакопления.РасчетыНалоговыхАгентовСБюджетомПоНДФЛ);
	
КонецФункции

#Область Свойства

// См. УправлениеСвойствамиПереопределяемый.ПриПолученииПредопределенныхНаборовСвойств.
Процедура ПриПолученииПредопределенныхНаборовСвойств(Наборы) Экспорт
	
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbfab-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf56-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf43-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ПерерасчетНДФЛ);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf32-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.ПрекращениеСтандартныхВычетовНДФЛ);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "d42dbf16-9802-11e9-80cd-4cedfb43b11a", Метаданные.Документы.УведомлениеОПравеНаИмущественныйВычетДляНДФЛ);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "3823219d-fe0f-4ffc-b19e-846f1882b5ea", Метаданные.Документы.ЕжегодныеСтандартныеВычеты);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "024f66f5-20e6-4a41-bd4b-bdb0907719f6", Метаданные.Документы.СведенияОДоходахСотрудникаДляСоцВыплат);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "2670afb7-d277-4562-842b-d218d1538054", Метаданные.Документы.СправкаНДФЛ);
	УправлениеСвойствамиБЗК.ЗарегистрироватьНаборСвойств(Наборы, "b270fe17-95dd-4c2d-889e-8aa23b39b573", Метаданные.Документы.СправкиНДФЛДляПередачиВНалоговыйОрган);
	
КонецПроцедуры

#КонецОбласти

#Область УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииСписковСОграничениемДоступа(Списки) Экспорт
	
	Списки.Вставить(Метаданные.Документы.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛ, Истина);
	Списки.Вставить(Метаданные.Справочники.ЗаявлениеНаПредоставлениеСтандартныхВычетовПоНДФЛПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ЗаявлениеОПодтвержденииПраваНаЗачетАвансовПоНДФЛ, Истина);
	Списки.Вставить(Метаданные.Документы.ПерерасчетНДФЛ, Истина);
	Списки.Вставить(Метаданные.Справочники.ПерерасчетНДФЛПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ПрекращениеСтандартныхВычетовНДФЛ, Истина);
	Списки.Вставить(Метаданные.Справочники.ПрекращениеСтандартныхВычетовНДФЛПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.СведенияОДоходахСотрудникаДляСоцВыплат, Истина);
	Списки.Вставить(Метаданные.Справочники.СведенияОДоходахСотрудникаДляСоцВыплатПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.СправкаНДФЛ, Истина);
	Списки.Вставить(Метаданные.Справочники.СправкаНДФЛПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.СправкиНДФЛДляПередачиВНалоговыйОрган, Истина);
	Списки.Вставить(Метаданные.Документы.УведомлениеОПравеНаИмущественныйВычетДляНДФЛ, Истина);
	Списки.Вставить(Метаданные.Справочники.УведомлениеОПравеНаИмущественныйВычетДляНДФЛПрисоединенныеФайлы, Истина);
	Списки.Вставить(Метаданные.Документы.ЕжегодныеСтандартныеВычеты, Истина);
	Списки.Вставить(Метаданные.Справочники.ЕжегодныеСтандартныеВычетыПрисоединенныеФайлы, Истина);
	
КонецПроцедуры

#КонецОбласти

#Область ОбновлениеИнформационнойБазы

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.17.6";
	Обработчик.Процедура = "УчетНДФЛДокументы.ДобавитьРолиДляДокументовУчетаНДФЛ";
	Обработчик.РежимВыполнения = "Оперативно";
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.1.17.118";
	Обработчик.РежимВыполнения = ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ОсновнойРежимВыполненияОбновления();
	Обработчик.Идентификатор   = Новый УникальныйИдентификатор("80ac665d-768c-11eb-810e-4cedfb95099a");
	Обработчик.Процедура = "УчетНДФЛДокументы.ОбновитьНДФЛПеречисленныйВозвратНДФЛ";
	Обработчик.Комментарий     = НСтр("ru = 'Обновление НДФЛ перечисленный, по возврату НДФЛ.';
										|en = 'Updating personal income tax transferred, on the return of personal income tax.'");
	
КонецПроцедуры

Процедура ОбновитьНДФЛПеречисленныйВозвратНДФЛ(ПараметрыОбновления = Неопределено) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	НДФЛПеречисленный.Регистратор КАК Регистратор
	|ИЗ
	|	РегистрНакопления.НДФЛПеречисленный КАК НДФЛПеречисленный
	|ГДЕ
	|	НДФЛПеречисленный.Регистратор ССЫЛКА Документ.ВозвратНДФЛ
	|
	|СГРУППИРОВАТЬ ПО
	|	НДФЛПеречисленный.Регистратор
	|
	|ИМЕЮЩИЕ
	|	(СУММА(НДФЛПеречисленный.Сумма) <> 0
	|		ИЛИ СУММА(НДФЛПеречисленный.СуммаСПревышения) <> 0)";
	РезультатЗапроса = Запрос.Выполнить();
	
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Ложь);
	Если РезультатЗапроса.Пустой() Тогда
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.УстановитьПараметрОбновления(ПараметрыОбновления, "ОбработкаЗавершена", Истина);
		Возврат;
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл
		
		Если Не ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(ПараметрыОбновления, "РегистрНакопления.НДФЛПеречисленный.НаборЗаписей", "Регистратор", Выборка.Регистратор) Тогда
			Продолжить;
		КонецЕсли;
		
		НаборЗаписей = РегистрыНакопления.НДФЛПеречисленный.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Регистратор.Установить(Выборка.Регистратор);
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		
		ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
		
	КонецЦикла;

КонецПроцедуры

#КонецОбласти

#Область КадровыйЭДО

Процедура ЗаполнитьНастройкиПечатныхФормПоУмолчанию(ОписанияНастроек) Экспорт
	
	КадровыйЭДО.ДобавитьНастройкуПечатнойФормы(
		ОписанияНастроек,
		"Форма2НДФЛ",
		НСтр("ru = 'Справка о доходах (2-НДФЛ)';
			|en = 'Income statement (2-NDFL)'"),
		Перечисления.СодержимоеДокументов.СодержитЗарплату,
		,
		,
		,
		Перечисления.ВариантыПодписанияДокументовКЭДО.НеТребуется);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ВыполнятьПроверкуЗаполненияКодовВычета(ДокументОбъект)
	
	МетаданныеДокумента = ДокументОбъект.Метаданные();
	Если МетаданныеДокумента.ТабличныеЧасти.Найти("НДФЛ") = Неопределено
		Или МетаданныеДокумента.ТабличныеЧасти.Найти("ПримененныеВычетыНаДетейИИмущественные") = Неопределено  Тогда
		
		Возврат Ложь;
	КонецЕсли;
	
	Возврат ДокументОбъект.НДФЛ.Количество() > 0;
	
КонецФункции

Функция КонфликтующиеРегистраторыВычетов(Регистратор, Месяц, Сотрудник, МассивВычетов) Экспорт
	
	Запрос = Новый Запрос;
	// АПК:96-выкл ОБЪЕДИНИТЬ является необходимым условием запроса
	Запрос.Текст =
		"ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	ПрименениеСтандартныхВычетовПоНДФЛ.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ПрименениеСтандартныхВычетовПоНДФЛ.Регистратор) КАК ПредставлениеРегистратора
		|ИЗ
		|	РегистрСведений.ПрименениеСтандартныхВычетовПоНДФЛ КАК ПрименениеСтандартныхВычетовПоНДФЛ
		|ГДЕ
		|	ПрименениеСтандартныхВычетовПоНДФЛ.Период = &Период
		|	И ПрименениеСтандартныхВычетовПоНДФЛ.ФизическоеЛицо = &ФизическоеЛицо
		|	И ПрименениеСтандартныхВычетовПоНДФЛ.Регистратор <> &Регистратор
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтандартныеВычетыНаДетейНДФЛ.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СтандартныеВычетыНаДетейНДФЛ.Регистратор)
		|ИЗ
		|	РегистрСведений.СтандартныеВычетыНаДетейНДФЛ КАК СтандартныеВычетыНаДетейНДФЛ
		|ГДЕ
		|	СтандартныеВычетыНаДетейНДФЛ.МесяцРегистрации = &Период
		|	И СтандартныеВычетыНаДетейНДФЛ.ФизическоеЛицо = &ФизическоеЛицо
		|	И СтандартныеВычетыНаДетейНДФЛ.КодВычета В(&КодыВычетов)
		|	И СтандартныеВычетыНаДетейНДФЛ.Регистратор <> &Регистратор
		|
		|ОБЪЕДИНИТЬ
		|
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	СтандартныеВычетыФизическихЛицНДФЛ.Регистратор,
		|	ПРЕДСТАВЛЕНИЕССЫЛКИ(СтандартныеВычетыФизическихЛицНДФЛ.Регистратор)
		|ИЗ
		|	РегистрСведений.СтандартныеВычетыФизическихЛицНДФЛ КАК СтандартныеВычетыФизическихЛицНДФЛ
		|ГДЕ
		|	СтандартныеВычетыФизическихЛицНДФЛ.ФизическоеЛицо = &ФизическоеЛицо
		|	И СтандартныеВычетыФизическихЛицНДФЛ.Период = &Период
		|	И СтандартныеВычетыФизическихЛицНДФЛ.Регистратор <> &Регистратор";
	// АПК:96-вкл
	Запрос.УстановитьПараметр("ФизическоеЛицо",	Сотрудник);
	Запрос.УстановитьПараметр("Период",			Месяц);
	Запрос.УстановитьПараметр("Регистратор",	Регистратор);
	Запрос.УстановитьПараметр("КодыВычетов",	МассивВычетов);
	
	Возврат Запрос;
	
КонецФункции

Процедура ОтменитьПрименениеВычетов(Регистратор, Сотрудник) Экспорт
	
	УчетНДФЛДокументыВнутренний.ОтменитьПрименениеВычетов(Регистратор, Сотрудник);
	
КонецПроцедуры

Процедура ДобавитьРолиДляДокументовУчетаНДФЛ() Экспорт
	
	ЗаменяемыеРоли = Новый Соответствие;
	
	НовыеРоли = Новый Массив;
	НовыеРоли.Добавить(Метаданные.Роли.ДобавлениеИзменениеНалоговИВзносов.Имя);
	НовыеРоли.Добавить(Метаданные.Роли.ДобавлениеИзменениеДокументовУчетаНДФЛ.Имя);
	ЗаменяемыеРоли.Вставить("ДобавлениеИзменениеНалоговИВзносов", НовыеРоли);
	
	НовыеРоли = Новый Массив;
	НовыеРоли.Добавить(Метаданные.Роли.ЧтениеНалоговИВзносов.Имя);
	НовыеРоли.Добавить(Метаданные.Роли.ЧтениеДокументовУчетаНДФЛ.Имя);
	ЗаменяемыеРоли.Вставить("ЧтениеНалоговИВзносов", НовыеРоли);
	
	УправлениеДоступом.ЗаменитьРолиВПрофилях(ЗаменяемыеРоли);
	
КонецПроцедуры

#КонецОбласти