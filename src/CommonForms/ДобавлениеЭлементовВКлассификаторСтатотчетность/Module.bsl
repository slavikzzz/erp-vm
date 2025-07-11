#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	УстановитьУсловноеОформление();

	// У отчета <ОтчетИсточникДанных> есть макет <ИмяМакетаСписков> (например: Списки2012Кв1)
	// в макете <ИмяМакетаСписков> в области <ОбластьИсточникДанных> 
	// содержатся коды и наименования элементов классификатора
	// реквизиты ОтчетИсточникДанных и ОбластьИсточникДанных получаем из параметров
	// ИмяМакетаСписков - берем по умолчанию последний макет.
	
	Назначение 				= Параметры.Назначение;
	ИмяСправочника 			= Перечисления.ВидыСвободныхСтрокФормСтатистики.ИмяСправочника(Назначение);

	НазначениеКлассификатора = "";
	Если Назначение = Перечисления.ВидыСвободныхСтрокФормСтатистики.ВидыУслугРозница Тогда
		НазначениеКлассификатора = "ВидыУслугРозница";
	КонецЕсли;
	
	ПараметрыКлассификатора = ИнтерфейсыВзаимодействияБРО.ПолучитьРасположениеКлассификатораСтатистики(ИмяСправочника, НазначениеКлассификатора);
	
	ОбластьИсточникДанных 	= ПараметрыКлассификатора.ОбластьИсточникДанных; 
	ОтчетИсточникДанных 	= ПараметрыКлассификатора.ОтчетИсточникДанных; 
	СписокВерсий 			= ИнтерфейсыВзаимодействияБРО.ПолучитьВерсииСписковОтчета(ОтчетИсточникДанных);
	Заголовок 				= Метаданные.Справочники[ИмяСправочника].Синоним;
	Подбор 					= Параметры.Подбор;
	
	Элементы.Классификатор.МножественныйВыбор = Подбор;
	ЗакрыватьПриВыборе = Не Подбор;
	
	Если СписокВерсий.Количество() = 0 Тогда
		
		Отказ = Истина;
		ВызватьИсключение НСтр("ru = 'Невозможно выполнить подбор.
		|Классификатор не найден';
		|en = 'Cannot perform picking.
		|Classifier is not found'");
		
	Иначе
		
		СписокВыбора = Элементы.ИмяМакетаСписков.СписокВыбора;
		
		Для Каждого Версия Из СписокВерсий Цикл
			
			СписокВыбора.Добавить(Версия.Значение, Версия.Представление);	
			
		КонецЦикла;	
		
		ИмяМакетаСписков = СписокВерсий[СписокВерсий.Количество() - 1].Значение;
		
	КонецЕсли;
	
	ИнициализироватьКлассификатор();
	
	Если Параметры.ДанныеКлассификатора Тогда
		
		ПолеНазначение = Элементы.Назначение;
		ПолеНазначение.Вид = ВидПоляФормы.ПолеНадписи;
		ПолеНазначение.ЦветТекста = ЦветаСтиля.ЗаблокированныйРеквизитЦвет;
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура НазначениеПриИзменении(Элемент)
	
	ЗаполнитьНазначение();
	
	УстановитьНазначение(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ИмяМакетаСписковПриИзменении(Элемент)
	
	ИмяМакетаСписковПриИзмененииСервер();

КонецПроцедуры

&НаКлиенте
Процедура НазначениеОчистка(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыКлассификатор

// Вызывается при двойном щелчке мыши или нажатии Enter.
//
&НаКлиенте
Процедура КлассификаторВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(ВыбраннаяСтрока, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

// Вызывается при нажатии на кнопку выбрать.
//
&НаКлиенте
Процедура КлассификаторВыборЗначения(Элемент, Значение, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ДобавленыНовыеЭлементыКлассификатора = Ложь;
	ВыбранныйЭлемент = КлассификаторВыборНаСервере(Значение, ДобавленыНовыеЭлементыКлассификатора);
	Если ВыбранныйЭлемент <> Неопределено Тогда
		ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора);
	КонецЕсли;
	
КонецПроцедуры

// Функция обрабатывает данные выбора пользователя.
//
// В случае если выбранные элементы классификатора отсутствуют в справочнике,
// они будут добавлены, также будет добавлена единица измерения элемента классификатора
// в справочник "КлассификаторЕдиницИзмерения" если в данном классификаторе используются 
// единицы измерения и если такой единицы нет в справочнике "КлассификаторЕдиницИзмерения".
//
// Если был осуществлен множественный выбор, то все выбранные элементы будут обработаны
// (добавлены в справочник в случае отсутствия), в возвращаемый параметр, будет передан
// массив ссылок на элементы.
//
// Параметры:
// 	ВыбранныеСтроки - Массив - Массив выбранных строк таблицы формы классификатор.
// 	ДобавленыНовыеЭлементыКлассификатора - Булево - Флаг устанавливается, 
// 	если в справочник были добавлены элементы.
//
// Возвращаемое значение:
// Неопределено или СправочникСсылка: 
// 		КлассификаторВидовЭкономическойДеятельности 
// 		или  КлассификаторПродукцииПоВидамДеятельности 
//		или КлассификаторУслугНаселению.
//
&НаСервере
Функция КлассификаторВыборНаСервере(Знач ВыбранныеСтроки, ДобавленыНовыеЭлементыКлассификатора = Ложь)

	СсылкаНаЭлемент = Неопределено;
	
	МассивСсылок = Новый Массив();
	
	Если ТипЗнч(ВыбранныеСтроки) = тип("Массив") Тогда
		
		Для Каждого ИдентификаторСтроки Из ВыбранныеСтроки Цикл
			
			Элемент = Классификатор.НайтиПоИдентификатору(ИдентификаторСтроки);
			
			Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
				
				ДобавитьЭлементКлассификатора(Элемент);
				ДобавленыНовыеЭлементыКлассификатора = Истина;
				
			КонецЕсли;
			
			МассивСсылок.Добавить(Элемент.Ссылка);
			СсылкаНаЭлемент = Элемент.Ссылка;
			
		КонецЦикла;	
		
	ИначеЕсли ТипЗнч(ВыбранныеСтроки) = тип("Число") Тогда	
		
		Элемент = Классификатор.НайтиПоИдентификатору(ВыбранныеСтроки);
		
		Если НЕ ЗначениеЗаполнено(Элемент.Ссылка) Тогда
			
			ДобавитьЭлементКлассификатора(Элемент);
			ДобавленыНовыеЭлементыКлассификатора = Истина;
			
		КонецЕсли;
		
		МассивСсылок.Добавить(Элемент.Ссылка);
		СсылкаНаЭлемент = Элемент.Ссылка;
		
	КонецЕсли;

	Если Подбор Тогда
		Возврат МассивСсылок;
	Иначе	
		Возврат СсылкаНаЭлемент;
	КонецЕсли;
	
 КонецФункции
 
#КонецОбласти
 
#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();


	// Классификатор

	ЭлементУО = УсловноеОформление.Элементы.Добавить();

	КомпоновкаДанныхКлиентСервер.ДобавитьОформляемоеПоле(ЭлементУО.Поля, "Классификатор");

	ОбщегоНазначенияКлиентСервер.ДобавитьЭлементКомпоновки(ЭлементУО.Отбор,
		"Классификатор.ЕстьСсылка", ВидСравненияКомпоновкиДанных.Равно, Истина);

	ЭлементУО.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветФонаВыделенияПоля);

КонецПроцедуры

// Заполняет колонку отбор в таблице классификатор исходя из переданной таблицы.
// Если Код из классификатора присутствует в "ТаблицеНазначения" в колонке "Отбор",
// проставляется - истина.
// В противном случае - ложь .
//
&НаСервере
Процедура ЗаполнитьКолонкуОтбор(ТаблицаОтбора)
	
	ТаблицаОтбора.Индексы.Добавить("Код");
	
	Для Каждого СтрокаКлассификатора Из Классификатор Цикл
		
		СтрокаКлассификатора.Отбор = ТаблицаОтбора.Найти(СтрокаКлассификатора.Код, "Код") <> Неопределено;	
		
	КонецЦикла;	 
	
КонецПроцедуры

&НаСервере
Функция ПолучитьРанееДобавленныеЭлементы()
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("ВидСвободныхСтрокФормСтатистики", Перечисления.ВидыСвободныхСтрокФормСтатистики.ЗначениеПоУмолчаниюДляКлассификатора(ИмяСправочника));
	
	ЗапросТекст = "ВЫБРАТЬ
	               |	%1.Код,
				   |	%1.Ссылка,
				   |	%2ВидСвободныхСтрокФормСтатистики КАК Назначение
	               |ИЗ
	               |	Справочник.%1 КАК %1";
				   
	МетаданныеСправочник = Метаданные.Справочники[ИмяСправочника];
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидСвободныхСтрокФормСтатистики", МетаданныеСправочник) Тогда
		ТекстПараметра2 = "%1.";
	Иначе
		ТекстПараметра2 = "&";
	КонецЕсли;
	
	ЗапросТекст = СтрЗаменить(ЗапросТекст, "%2", ТекстПараметра2);			   
	Запрос.Текст = СтрЗаменить(ЗапросТекст, "%1", ИмяСправочника);			   
	
	Возврат Запрос.Выполнить().Выгрузить();			   
				   
КонецФункции	

// Заполняет классификатор данными
// Параметры:
// 	ИспользоватьТаблицуОтбора - Булево - если истина то классификатор можно заполнить
//	 используя таблицу отбора, а не весь классификатор.
//
&НаСервере
Процедура ЗаполнитьКлассификатор(ИспользоватьТаблицуОтбора = Ложь)
	
	Классификатор.Очистить();
	
	// Получаем параметры справочника нужные для корректного чтения классификатора.
	ДополнятьКодПриЧтенииДанныхКлассификатора = Справочники[ИмяСправочника].ДополнятьКодПриЧтенииДанныхКлассификатора();
	ДлинаКодаСправочника = Метаданные.Справочники[ИмяСправочника].ДлинаКода;
	
	// Получаем полную таблицу элементов классификатора.
	// В таблице содержатся Код и Наименование, элементов классификатора.
	ЭлементыКлассификатораИзМакета = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
		ОтчетИсточникДанных, 
		ИмяМакетаСписков, 
		ОбластьИсточникДанных,
		ДополнятьКодПриЧтенииДанныхКлассификатора,
		ДлинаКодаСправочника);
		
	// Получаем таблицу элементов классификатора уже имеющихся в справочнике.
	РанееДобавленныеЭлементыКлассификатора 	= ПолучитьРанееДобавленныеЭлементы();
	РанееДобавленныеЭлементыКлассификатора.Индексы.Добавить("Код");
	РанееДобавленныеЭлементыКлассификатора.Индексы.Добавить("Назначение");
	
	// Если классификатор будем строить исходя из таблицы отбора,
	// то нужно ее получить.
	Если ИспользоватьТаблицуОтбора Тогда
		
		ОбластьИсточникОтбора = Перечисления.ВидыСвободныхСтрокФормСтатистики.ИмяОбластиМакетаОграничения(Назначение, ИмяМакетаСписков);
		ЭлементыКлассификатора = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
			ОтчетИсточникДанных, 
			ИмяМакетаСписков, 
			ОбластьИсточникОтбора);
		ЭлементыКлассификатораИзМакета.Индексы.Добавить("Код");
		
	Иначе
		
		ЭлементыКлассификатора = ЭлементыКлассификатораИзМакета;
		
	КонецЕсли;
	
	Если ЭлементыКлассификатора.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Инициализируем структуру, которую будем использовать для поиска существующих элементов.
	СтруктураПоискаРанееСозданных = Новый Структура();
	
	Для Каждого Элемент Из ЭлементыКлассификатора Цикл
		
		НоваяСтрока = Классификатор.Добавить();
		НоваяСтрока.Код   = Элемент.Код;
		НоваяСтрока.Отбор = ИспользоватьТаблицуОтбора; // Если используется таблица отбора, то в ЭлементыКлассификатора только отобранные элементы
		
		Наименование = "";
		Если Не ИспользоватьТаблицуОтбора Тогда
			Наименование = Элемент.Наименование;
		Иначе
			// В таблице отбора содержатся только коды элементов классификатора.
			// ЭлементыКлассификатора - это таблица отбора, а не таблица классификатора.
			// Поэтому наименование нужно подставить из общей таблицы.
			КлассификаторИзМакета = ЭлементыКлассификатораИзМакета.Найти(Элемент.Код, "Код");
			Если КлассификаторИзМакета <> Неопределено Тогда
				Наименование = КлассификаторИзМакета.Наименование;
			КонецЕсли;
		КонецЕсли;
		НоваяСтрока.Наименование = Наименование;
		
		СтруктураПоискаРанееСозданных.Вставить("Код",        Элемент.Код);
		СтруктураПоискаРанееСозданных.Вставить("Назначение", Назначение);
		НайденныйЭлемент = РанееДобавленныеЭлементыКлассификатора.НайтиСтроки(СтруктураПоискаРанееСозданных);
		
		Если НайденныйЭлемент.Количество() > 0 Тогда
			
			НоваяСтрока.Ссылка = НайденныйЭлемент[0].Ссылка;
			НоваяСтрока.ЕстьСсылка = Истина;
			
		КонецЕсли;
		
	КонецЦикла;
		
	Классификатор.Сортировать("ЕстьСсылка Убыв, Код Возр");
		
КонецПроцедуры	

// Получает таблицу единиц измерения из списков отчета
// и вызывает заполнение колонок "ЕдиницаИзмерения" и "ЕдиницаИзмеренияКод" классификатора
// Параметры:
// 	ОбластьЕдиницаИзмерения - Строка - Название области содержащей данные о единицах измерения.
//	Если Неопределено, заполнение не происходит а колонка с единицей измерения становиться невидимой.
//
&НаСервере
Процедура ПоказатьЕдиницыИзмерения(ОбластьЕдиницаИзмерения = Неопределено)
	
	ВидимостьКолонкиЕИ = Ложь;
	
	Если ОбластьЕдиницаИзмерения <> Неопределено Тогда 
		
		ТаблицаЕдиниц = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(
			ОтчетИсточникДанных, 
			ИмяМакетаСписков, 
			ОбластьЕдиницаИзмерения);
		
		Если ТаблицаЕдиниц.Количество() > 0 И ТаблицаЕдиниц.Колонки.Найти("okp") <> Неопределено Тогда
			
			ВидимостьКолонкиЕИ = Истина;	
			
			ТаблицаЕдиниц.Индексы.Добавить("okp");
			
			Для Каждого СтрокаКлассификатора Из Классификатор Цикл
				
				СтрокаЕдиницаИзмерения = ТаблицаЕдиниц.Найти(СтрокаКлассификатора.Код, "okp");
				
				Если СтрокаЕдиницаИзмерения <> Неопределено Тогда
					
					СтрокаКлассификатора.ЕдиницаИзмерения 		= СтрокаЕдиницаИзмерения.Наименование;
					СтрокаКлассификатора.ЕдиницаИзмеренияКод 	= СтрокаЕдиницаИзмерения.Код;
					
				КонецЕсли;
				
			КонецЦикла;	 
			
		КонецЕсли;
		
	КонецЕсли;
	
	Элементы.Классификатор.ПодчиненныеЭлементы.ЕдиницаИзмерения.Видимость = ВидимостьКолонкиЕИ;
	Элементы.Классификатор.ПодчиненныеЭлементы.КлассификаторЕдиницаИзмеренияКод.Видимость = ВидимостьКолонкиЕИ;

КонецПроцедуры	

// Получает таблицу отбора из списков отчета
// и вызывает заполнение колонки "Отбор" классификатора,
// т.к. состав единиц измерения напрямую зависит от отбора, вызывается и загрузка единиц.
//
&НаСервере
Процедура ЗаполнитьНазначение()
	
	ОбластьИсточникОтбора = Перечисления.ВидыСвободныхСтрокФормСтатистики.ИмяОбластиМакетаОграничения(Назначение, ИмяМакетаСписков);
	
	ТаблицаОтбора = ИнтерфейсыВзаимодействияБРО.ПолучитьЗначенияИзСпискаВыбораОтчета(ОтчетИсточникДанных, ИмяМакетаСписков, ОбластьИсточникОтбора);
	
	Если ТаблицаОтбора.Количество() > 0 Тогда
		
		ЗаполнитьКолонкуОтбор(ТаблицаОтбора);
		
		ОбластьЕдиницаИзмерения = Перечисления.ВидыСвободныхСтрокФормСтатистики.ИмяОбластиЕдиницаИзмерения(Назначение);
		
		Если ОбластьЕдиницаИзмерения <> Неопределено Тогда
			
			ПоказатьЕдиницыИзмерения(ОбластьЕдиницаИзмерения);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

// Добавляет новый элемент в классификатор
// Параметры:
// 	ВыбраннаяСтрока - Строка таблицы - Источник данных для заполнения реквизитов классификатора.
// 		Если в строке присутствуют данные о единице измерения, 
//		запускается поиск и добавление единицы измерения.
//
&НаСервере
Процедура ДобавитьЭлементКлассификатора(ВыбраннаяСтрока)
	
	ЭлементКлассификатора = Справочники[ИмяСправочника].СоздатьЭлемент();
	ЗаполнитьЗначенияСвойств(ЭлементКлассификатора, ВыбраннаяСтрока);
	ЭлементКлассификатора.НаименованиеПолное = ВыбраннаяСтрока.Наименование;
	
	МетаданныеСправочник = Метаданные.Справочники[ИмяСправочника];
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ВидСвободныхСтрокФормСтатистики", МетаданныеСправочник) Тогда
		
		ЭлементКлассификатора.ВидСвободныхСтрокФормСтатистики = Назначение;
		
	КонецЕсли;
	
	Если ОбщегоНазначения.ЕстьРеквизитОбъекта("ЕдиницаСтатистическогоУчета", МетаданныеСправочник) И ЗначениеЗаполнено(ВыбраннаяСтрока.ЕдиницаИзмеренияКод) Тогда
		
		ЕдиницаИзмерения = ЕдиницаИзмеренияПоКоду(ВыбраннаяСтрока.ЕдиницаИзмеренияКод, ВыбраннаяСтрока.ЕдиницаИзмерения);
		ЭлементКлассификатора.ЕдиницаСтатистическогоУчета = ЕдиницаИзмерения;
		
	КонецЕсли;
	
	ЭлементКлассификатора.Записать();
	ВыбраннаяСтрока.Ссылка = ЭлементКлассификатора.Ссылка;
	
КонецПроцедуры	

// Выполняет поиск единицы измерения в справочнике "КлассификаторЕдиницИзмерения",
// если элемент в справочнике не найден, осуществляется попытка добавления элемента из ОКЕИ,
// если в ОКЕИ элемент не найден, то он создается с переданным кодом и наименованием.
//
// Параметры:
// - ЕдиницаИзмеренияКод - Строка(3) - Код единицы измерения по ОКЕИ.
// - Наименование - Строка - Наименование единицы измерения.
//
&НаСервере
Функция ЕдиницаИзмеренияПоКоду(ЕдиницаИзмеренияКод, Наименование)
	
	// Приводим код единицы измерения к формату ОКЕИ
	Код = СтроковыеФункцииКлиентСервер.ДополнитьСтроку(ЕдиницаИзмеренияКод, 3);
	
	ЕдиницаИзмерения = ЗаполнениеФормСтатистикиПереопределяемый.ЕдиницаИзмеренияПоКоду(Код, Наименование);
	
	Возврат ЕдиницаИзмерения;
	
КонецФункции	

// Вызывает оповещение об изменении справочника,
// вызывает оповещение пользователя,
// закрывает форму подбора из классификатора.
//
&НаКлиенте
Процедура ОповеститьФормуИПользователяИЗакрыть(ВыбранныйЭлемент, ДобавленыНовыеЭлементыКлассификатора = Ложь)
	
	Если ДобавленыНовыеЭлементыКлассификатора Тогда
		
		ОповеститьОбИзменении(Тип("СправочникСсылка." + ИмяСправочника));	
		
		ПоказатьОповещениеПользователя(
		НСтр("ru = 'Сохранение';
			|en = 'Save'"),
		,
		ЭтаФорма.Заголовок,
		БиблиотекаКартинок.Информация32);
	КонецЕсли;
	
	ОповеститьОВыборе(ВыбранныйЭлемент);
	
КонецПроцедуры


// Заполняет список выбора реквизита "Назначение" и устанавливает значение отбора по умолчанию.
//
&НаСервере
Процедура ИнициализироватьКлассификатор()
	
	// Если подбор в классификатор был открыт из самого классификатора, то назначение нужно задать по умолчанию.
	Если НЕ ЗначениеЗаполнено(Назначение) Тогда
		
		Назначение = Перечисления.ВидыСвободныхСтрокФормСтатистики.ЗначениеПоУмолчаниюДляКлассификатора(ИмяСправочника);
		
	КонецЕсли;	
	
	// Считываем список назначений классификатора
	// от количества элементов в этом списке зависят:
	// Видимость поля Назначение, если в списке 1 элемент, то поле Назначение скрывается
	// за ненадобностью, а в классификатор выводится сразу ограниченный список.
	// Если в списке нет значений то Назначение также скрывается, а классификатор выводится как есть.
	// Если в списке больше чем 1 значение, поле Назначение становится видимым, классификатор заполняется
	// всеми элементами, а колонка классификатора - отбор заполняется значением истина, только для 
	// элементов соответствующих текущему выбранному назначению. В классификаторе устанавливается отбор 
	// по значению колонки отбор = истина. При изменение назначения колонка отбор перезаполняется.
	СписокНазначенийДляКлассификатора = Перечисления.ВидыСвободныхСтрокФормСтатистики.СписокНазначенийДляКлассификатора(ИмяСправочника);
	
	СписокНазначенийДляКлассификатораКоличество = СписокНазначенийДляКлассификатора.Количество();
	
	// Если существует несколько назначений
	Если СписокНазначенийДляКлассификатораКоличество > 1 Тогда
		
		СписокВыбора = Элементы.Назначение.СписокВыбора;
		
		Для каждого Ограничение Из СписокНазначенийДляКлассификатора Цикл 
			
			СписокВыбора.Добавить(Ограничение.Значение, Ограничение.Представление);
			СписокНазначений.Добавить(Ограничение.Значение, Ограничение.Представление);
			
		КонецЦикла;
		
		ЗаполнитьКлассификатор();
		
		ЗаполнитьНазначение();
		
		УстановитьНазначение(ЭтаФорма);
		
	// Если назначение одно
	ИначеЕсли СписокНазначенийДляКлассификатораКоличество > 0 Тогда
		
		Элементы.Назначение.Видимость = Ложь;
		ЗаполнитьКлассификатор(Истина);
		
	// Список назначений пуст	
	Иначе
		
		Элементы.Назначение.Видимость = Ложь;
		ЗаполнитьКлассификатор();
		
	КонецЕсли;
	
КонецПроцедуры

// Устанавливает отбор в таблице "Классификатор"
//
&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьНазначение(Форма)
	 
	 Если ЗначениеЗаполнено(Форма.Назначение) Тогда
		 
		 Форма.Элементы.Классификатор.ОтборСтрок = Новый ФиксированнаяСтруктура("Отбор", Истина);
		 
	 КонецЕсли;
	 
КонецПроцедуры

&НаСервере
Процедура ИмяМакетаСписковПриИзмененииСервер()
	
	ЗаполнитьКлассификатор();
	
	Если СписокНазначений.Количество() > 0 Тогда
		
		ЗаполнитьНазначение();
		
		УстановитьНазначение(ЭтаФорма);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
