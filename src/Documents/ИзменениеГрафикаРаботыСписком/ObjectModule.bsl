#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	Документы.ИзменениеГрафикаРаботыСписком.ЗаполнитьДатуЗапретаРедактирования(ЭтотОбъект);
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	ЗарплатаКадры.ПроверитьКорректностьДаты(Ссылка, ДатаИзменения, "Объект.ДатаИзменения", Отказ, НСтр("ru = 'Дата изменения';
																										|en = 'Change date'"), , , Ложь);
	
	ИсправлениеДокументовЗарплатаКадры.ПроверитьЗаполнение(ЭтотОбъект, ПроверяемыеРеквизиты, Отказ, "ПериодическиеСведения");
	
	ПараметрыПолученияСотрудниковОрганизаций = КадровыйУчет.ПараметрыПолученияСотрудниковОрганизацийПоСпискуФизическихЛиц();
	ПараметрыПолученияСотрудниковОрганизаций.Организация				= Организация;
	ПараметрыПолученияСотрудниковОрганизаций.Подразделение				= Подразделение;
	ПараметрыПолученияСотрудниковОрганизаций.НачалоПериода				= ДатаИзменения;
	ПараметрыПолученияСотрудниковОрганизаций.ОкончаниеПериода			= ДатаОкончания;
	ПараметрыПолученияСотрудниковОрганизаций.РаботникиПоДоговорамГПХ	= Неопределено;
	ПараметрыПолученияСотрудниковОрганизаций.ИсключаемыйРегистратор		= Ссылка;
	
	КадровыйУчет.ПроверитьРаботающихСотрудников(
		Сотрудники.ВыгрузитьКолонку("Сотрудник"),
		ПараметрыПолученияСотрудниковОрганизаций,
		Отказ,
		Новый Структура("ИмяПоляСотрудник, ИмяОбъекта", "Сотрудник", "Объект.Сотрудники"));
	
	Если ДатаИзменения > ДатаОкончания
		И ЗначениеЗаполнено(ДатаОкончания) Тогда
		
		ОбщегоНазначения.СообщитьПользователю(НСтр("ru = 'Дата окончания не может быть меньше даты начала изменения графика работы';
													|en = 'End date cannot be less than the start date of the work schedule change'"), ЭтотОбъект, "ДатаОкончания", ,Отказ);
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
		
	// Проведение документа
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект, , , ЗначениеЗаполнено(ИсправленныйДокумент));
	ЗарплатаКадрыРасширенный.ИнициализироватьОтложеннуюРегистрациюВторичныхДанныхПоДвижениямДокумента(Движения);
	
	ИсправлениеПериодическихСведений.ИсправлениеПериодическихСведений(ЭтотОбъект, Отказ, РежимПроведения);
	
	ДанныеПроведения = ПолучитьДанныеДляПроведения();
	
	ЗарплатаКадрыРасширенный.УстановитьВремяРегистрацииДокумента(Движения, ДанныеПроведения.СотрудникиДаты, Ссылка);
	
	КадровыйУчетРасширенный.СформироватьИсториюИзмененияГрафиков(Движения, ДанныеПроведения.СотрудникиДаты);
	
	СтруктураПлановыхНачислений = Новый Структура;
	СтруктураПлановыхНачислений.Вставить("ДанныеОПлановыхНачислениях", ДанныеПроведения.ПлановыеНачисления);
	РасчетЗарплаты.СформироватьДвиженияПлановыхНачислений(ЭтотОбъект, Движения, СтруктураПлановыхНачислений);
	
	УчетСтажаПФР.ЗарегистрироватьПериодыВУчетеСтажаПФР(Движения, ДанныеДляРегистрацииВУчетаСтажаПФР());
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
		
	ПроведениеСервер.ПодготовитьНаборыЗаписейКУдалениюПроведения(ЭтотОбъект, ЗначениеЗаполнено(ИсправленныйДокумент));
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.ИзменениеГрафикаРаботыСписком") Тогда
		ЗначенияРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
			ДанныеЗаполнения, "ДатаИзменения,ДатаОкончания,Организация,Подразделение,ГрафикРаботы");
		Дата = ТекущаяДатаСеанса();
		ДатаИзменения = ЗначенияРеквизитов.ДатаИзменения;
		ДатаОкончания = ЗначенияРеквизитов.ДатаОкончания;
		Организация = ЗначенияРеквизитов.Организация;
		Подразделение = ЗначенияРеквизитов.Подразделение;
		ГрафикРаботы = ЗначенияРеквизитов.ГрафикРаботы;
		
		ЗаполнитьДокумент(ЗначенияРеквизитов.ДатаИзменения);
	ИначеЕсли ТипЗнч(ДанныеЗаполнения) = Тип("Структура") Тогда
		Если ДанныеЗаполнения.Свойство("Действие") И ДанныеЗаполнения.Действие = "Исправить" Тогда
			
			ИсправлениеДокументовЗарплатаКадры.СкопироватьДокумент(ЭтотОбъект, ДанныеЗаполнения.Ссылка);
			
			ИсправленныйДокумент = ДанныеЗаполнения.Ссылка;
			
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьДокумент(ВремяРегистрации) Экспорт
	
	ВремяНачалаЗамера = ОценкаПроизводительности.НачатьЗамерВремени();
	
	Менеджер = Документы.ИзменениеГрафикаРаботыСписком;
	
	Сотрудники.Очистить();
	НачисленияСотрудников.Очистить();
	ПересчетТарифныхСтавок.Очистить();
	
	МассивСотрудников = Менеджер.СотрудникиДляИзмененияГрафика(Организация, Подразделение, ГрафикРаботы, ДатаИзменения);
	
	ТаблицаНачисленийСотрудников = Документы.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников(
		Ссылка, ДатаИзменения, МассивСотрудников);
	
	Менеджер.РассчитатьФОТ(Ссылка, Организация, ДатаИзменения, ГрафикРаботы, ТаблицаНачисленийСотрудников, ПересчетТарифныхСтавок);
	
	Для Каждого Сотрудник Из МассивСотрудников Цикл
		
		Если ТаблицаНачисленийСотрудников.Найти(Сотрудник, "Сотрудник") <> Неопределено Тогда
			
			НоваяСтрокаСотрудника = Сотрудники.Добавить();
			НоваяСтрокаСотрудника.Сотрудник = Сотрудник;
			НоваяСтрокаСотрудника.ФиксСтрока = Ложь;
			
		КонецЕсли;
		
	КонецЦикла;
	
	НачисленияСотрудников.Загрузить(ТаблицаНачисленийСотрудников);
	
	ОценкаПроизводительности.ЗакончитьЗамерВремени("ЗаполнениеДокументаИзменениеГрафикаРаботыСписком",
		ВремяНачалаЗамера);
	
КонецПроцедуры

// Необходимо получить данные для формирования движений
//		кадровой истории - см. КадровыйУчетРасширенный.СформироватьКадровыеДвижения
//		плановых начислений - см. РасчетЗарплатыРасширенный.СформироватьДвиженияПлановыхНачислений
//		плановых выплат (авансы) - см. РасчетЗарплаты.СформироватьДвиженияПлановыхВыплат.
// 
Функция ПолучитьДанныеДляПроведения()
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.УстановитьПараметр("ДатаИзменения", ДатаИзменения);
	Запрос.УстановитьПараметр("ДатаОкончания", ДатаОкончания);
	Запрос.УстановитьПараметр("Организация", Организация);
	
	Запрос.Текст =
	"ВЫБРАТЬ
	|	&ДатаИзменения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА &ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(&ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ &ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Сотрудник КАК Сотрудник,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Сотрудник.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Сотрудник.ГоловнаяОрганизация КАК ГоловнаяОрганизация,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Начисление КАК Начисление,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.ДокументОснование КАК ДокументОснование,
	|	ИСТИНА КАК Используется,
	|	ИСТИНА КАК ИспользуетсяПоОкончании,
	|	ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Размер КАК Размер
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников КАК ИзменениеГрафикаРаботыСпискомНачисленияСотрудников
	|ГДЕ
	|	НЕ ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Начисление.ФОТНеРедактируется
	|	И ИзменениеГрафикаРаботыСпискомНачисленияСотрудников.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	&ДатаИзменения КАК ДатаСобытия,
	|	ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Сотрудник КАК Сотрудник,
	|	СправочникСотрудники.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ИзменениеГрафикаРаботыПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка КАК Значение,
	|	ВЫБОР
	|		КОГДА ИзменениеГрафикаРаботыПересчетТарифныхСтавок.СовокупнаяТарифнаяСтавка = 0
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.ВидыТарифныхСтавок.ПустаяСсылка)
	|		ИНАЧЕ ИзменениеГрафикаРаботыПересчетТарифныхСтавок.ВидТарифнойСтавки
	|	КОНЕЦ КАК ВидТарифнойСтавки,
	|	ВЫБОР
	|		КОГДА ИзменениеГрафикаРаботыСписком.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеГрафикаРаботыСписком.ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ ИзменениеГрафикаРаботыСписком.ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.ПересчетТарифныхСтавок КАК ИзменениеГрафикаРаботыПересчетТарифныхСтавок
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеГрафикаРаботыСписком КАК ИзменениеГрафикаРаботыСписком
	|		ПО ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Ссылка = ИзменениеГрафикаРаботыСписком.Ссылка
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Сотрудники КАК СправочникСотрудники
	|		ПО ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Сотрудник = СправочникСотрудники.Ссылка
	|ГДЕ
	|	ИзменениеГрафикаРаботыПересчетТарифныхСтавок.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	&ДатаИзменения КАК ДатаСобытия,
	|	ВЫБОР
	|		КОГДА ИзменениеГрафикаРаботыСписком.ДатаОкончания > ДАТАВРЕМЯ(1, 1, 1)
	|			ТОГДА ДОБАВИТЬКДАТЕ(ИзменениеГрафикаРаботыСписком.ДатаОкончания, ДЕНЬ, 1)
	|		ИНАЧЕ ИзменениеГрафикаРаботыСписком.ДатаОкончания
	|	КОНЕЦ КАК ДействуетДо,
	|	ИзменениеГрафикаРаботыНачисленияСотрудников.Сотрудник КАК Сотрудник,
	|	ИзменениеГрафикаРаботыСписком.ГрафикРаботы КАК ГрафикРаботы,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыКадровыхСобытий.Перемещение) КАК ВидСобытия
	|ИЗ
	|	Документ.ИзменениеГрафикаРаботыСписком.НачисленияСотрудников КАК ИзменениеГрафикаРаботыНачисленияСотрудников
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.ИзменениеГрафикаРаботыСписком КАК ИзменениеГрафикаРаботыСписком
	|		ПО ИзменениеГрафикаРаботыНачисленияСотрудников.Ссылка = ИзменениеГрафикаРаботыСписком.Ссылка
	|ГДЕ
	|	ИзменениеГрафикаРаботыНачисленияСотрудников.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	ИзменениеГрафикаРаботыНачисленияСотрудников.Сотрудник,
	|	ИзменениеГрафикаРаботыСписком.ДатаОкончания,
	|	ИзменениеГрафикаРаботыСписком.ГрафикРаботы";
	
	РезультатыЗапроса = Запрос.ВыполнитьПакет();
	
	ДанныеДляПроведения = Новый Структура; 
	ДанныеДляПроведения.Вставить("ПлановыеНачисления",				РезультатыЗапроса[0].Выгрузить());
	ДанныеДляПроведения.Вставить("ДанныеСовокупныхТарифныхСтавок",	РезультатыЗапроса[1].Выгрузить());
	ДанныеДляПроведения.Вставить("СотрудникиДаты", 					РезультатыЗапроса[2].Выгрузить());
	
	Возврат ДанныеДляПроведения;
	
КонецФункции

Функция ДанныеДляРегистрацииВУчетаСтажаПФР()
	
	МассивСсылок = Новый Массив;
	МассивСсылок.Добавить(Ссылка);
	
	ДанныеДляРегистрацииВУчете = Документы.ИзменениеГрафикаРаботыСписком.ДанныеДляРегистрацииВУчетаСтажаПФР(МассивСсылок);
	
	Возврат ДанныеДляРегистрацииВУчете[Ссылка];
	
КонецФункции

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.';
						|en = 'Invalid object call on the client.'");
#КонецЕсли